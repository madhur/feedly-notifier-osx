//
//  FeedApi.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 21 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Foundation

struct FeedApi {
    weak var feedDataDelegate: FeedDataDelegate?
    weak var feedGeneralSettingsDataDelegate: FeedGeneralSettingsDataDelegate?
    weak var feedAdvancedSettingsDataDelegate: FeedAdvancedSettingsDataDelegate?
    
    init (feedDataDelegate: FeedDataDelegate) {
        self.feedDataDelegate = feedDataDelegate
    }
    init(feedGeneralSettingsDataDelegate: FeedGeneralSettingsDataDelegate) {
        self.feedGeneralSettingsDataDelegate = feedGeneralSettingsDataDelegate
    }
    init(feedAdvancedSettingsDataDelegate: FeedAdvancedSettingsDataDelegate) {
        self.feedAdvancedSettingsDataDelegate = feedAdvancedSettingsDataDelegate
    }
    
    func getToken() -> String? {
        let token = DefaultsUtil.defaults().get(key: DefaultKeys.ACCESS_TOKEN)
       // print("token " + token!)
        return token
    }
    
    func getCategories() {
        URLSession.shared.dataTask(with: getRequest(url: Constants.FEEDLY_HOST + Constants.CATEGORIES_URL)) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                let res = try JSONDecoder().decode([CategoryResponse].self, from: data)
                DispatchQueue.main.async {
                    self.feedGeneralSettingsDataDelegate?.categoriesFetched(categoriesResponse: res)
                }
                // print(res)
            } catch let error {
                print(error)
            }
            
        }.resume()
    }
    
    func getUnreadCounts() {
        URLSession.shared.dataTask(with: getRequest(url: Constants.FEEDLY_HOST + Constants.COUNTS_URL)) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                let res = try JSONDecoder().decode(CountsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.feedDataDelegate?.updateCounts(countsResponse: res)
                }
                 //print(res)
            } catch let error {
                print(error)
            }
            
        }.resume()
        
    }
    
    func markRead(entries: [String], loadMoreData: Bool) {
        let json: [String: Any] = [
            "action": "markAsRead",
            "type": "entries",
            "entryIds": entries
        ]
        
        let jsonData = (try? JSONSerialization.data(withJSONObject: json))!
        URLSession.shared.dataTask(with: postRequest(url: (Constants.FEEDLY_HOST + Constants.MARK_READ_URL), jsonData: jsonData)) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                DispatchQueue.main.async {
                    self.feedDataDelegate?.feedDataMarkedRead(loadMoreData: loadMoreData)
                }
                //print("marked unread")
            } catch let error {
                print(error)
            }
            
        }.resume()
        
    }
    
    func getStream(ranked: Int, pageSize: Int, unreadOnly: Bool = true) {
        
        let ranking: Ranking = Ranking(rawValue: ranked)!
        let ranked: String = ranking.getRankingStr()
        let queryItems = [URLQueryItem(name: "unreadOnly", value: String(unreadOnly)), URLQueryItem(name: "count", value: String(pageSize)), URLQueryItem(name: "ranked", value: ranked)]
        let url = getStreamsUrl(queryItems)
        print(url.absoluteString)
        URLSession.shared.dataTask(with: getRequest(url: url.absoluteString)) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
               // print ("Madhur")
                 if let httpResponse = response as? HTTPURLResponse {
                       
                    if httpResponse.statusCode == 401 {
                        self.refreshToken()
                        return
                    }
                }
                let data1 =  try JSONSerialization.jsonObject(with: data, options: []) // first of all convert json
                
                print(data1) // <-- here is ur string
                let res = try JSONDecoder().decode(StreamResponse.self, from: data)
                print(res.items.count)
                
                DispatchQueue.main.async {
                    self.feedDataDelegate?.feedDataUpdated(streamResponse: res)
                }
                
                
            } catch let error {
                print(error)
               
            }
            
        }.resume()
    
    }
    
    func refreshToken() {
        let refreshToken = DefaultsUtil.defaults().get(key: DefaultKeys.REFRESH_TOKEN)
        
        let json: [String: Any] = [
            "client_id": Constants.CLIENT_ID,
                   "client_secret": Constants.API_KEY,
                   "refresh_token" : refreshToken,
                   "grant_type": "refresh_token"
                  
               ]
               
               let jsonData = try? JSONSerialization.data(withJSONObject: json)
               print(jsonData)
               // create post request
               let url = URL(string: Constants.FEEDLY_HOST + Constants.TOKEN_AUTH_URL)!
               print(url.absoluteString)
               var request = URLRequest(url: url)
               request.httpMethod = "POST"
               request.addValue("application/json", forHTTPHeaderField: "content-type")
               
               // insert json data to the request
               request.httpBody = jsonData
               
               let task = URLSession.shared.dataTask(with: request) { data, response, error in
                   guard let data = data, error == nil else {
                       print(error?.localizedDescription ?? "No data")
                       return
                   }
                   
                   do {
                      self.printResponse(data: data)
                       if let httpResponse = response as? HTTPURLResponse {
                              print("statusCode: \(httpResponse.statusCode)")
                           if httpResponse.statusCode == 401 {
                              
                               return
                           }
                       }
                       
                       let decoder = JSONDecoder()
                       let tokenResponse = try decoder.decode(RefreshTokenResponse.self, from: data)
                       print(tokenResponse)
                       DefaultsUtil.defaults().save(key: DefaultKeys.ACCESS_TOKEN, value: tokenResponse.access_token)
                       self.feedDataDelegate?.tokenRefreshed()
                      
                   }
                   catch let parsingError {
                       print("Error", parsingError)
                   }
               }
               
               task.resume()
    }
    
    func printResponse(data: Data) {
        do {
            let data1 =   try JSONSerialization.jsonObject(with: data, options: []) // first of all convert json
            print(data1) // <-- here is ur string
        }
        catch let error {
                     print(error)
                    
        }
    }
    
    func getProfile() {
        URLSession.shared.dataTask(with: getRequest(url: Constants.FEEDLY_HOST + Constants.PROFILE_URL)) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                let res = try JSONDecoder().decode(ProfileResponse.self, from: data)
                // Save the user id into preference
                DefaultsUtil.defaults().save(key: DefaultKeys.USER_ID, value: res.id)
                print(res)
                DispatchQueue.main.async {
                    self.feedAdvancedSettingsDataDelegate?.profileFetched(profile: res)
                }
            } catch let error {
                print(error)
            }
            
        }.resume()
    }
    
    func getRequest(url : String) -> URLRequest {
        let url = URL(string: url)!
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("OAuth " + getToken()!, forHTTPHeaderField: "Authorization")
        return request
    }
    
    func postRequest(url : String, jsonData: Data) -> URLRequest {
        let url = URL(string: url)!
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        request.addValue("OAuth " + getToken()!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        return request
    }
    
    func getStreamsUrl(_ queryItems: [URLQueryItem]) -> URL {
        var initUrl = Constants.FEEDLY_HOST + Constants.STREAMS_URL
        var categoryUrl = Constants.GLOBAL_GROUP
        categoryUrl = categoryUrl.replacingOccurrences(of: Constants.USER_ID_VARIABLE, with: getUserId())
        print(categoryUrl)
        categoryUrl = categoryUrl.replacingOccurrences(of: "/", with: "%2f")
        initUrl = initUrl.replacingOccurrences(of: Constants.CATEGORY_VARIABLE, with: categoryUrl)
        
        var urlComps = URLComponents(string: initUrl)!
        urlComps.queryItems = queryItems
        let url = urlComps.url!
        return url
    }
    
    func getUserId() -> String {
        return DefaultsUtil.defaults().get(key: DefaultKeys.USER_ID)!
    }
    
}
