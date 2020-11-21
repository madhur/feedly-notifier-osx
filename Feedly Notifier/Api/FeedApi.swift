//
//  FeedApi.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 21 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Foundation

struct FeedApi {
    
    func getToken() -> String? {
        let token = DefaultsUtil.defaults().get(key: DefaultKeys.ACCESS_TOKEN)
        print("token " + token!)
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
                print(res)
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
                       print(res)
                   } catch let error {
                       print(error)
                   }
                   
               }.resume()
        
    }
    
    func markRead(entries: [String]) {
        let json: [String: Any] = [
                   "action": "markAsRead",
                   "type": "enties",
                   "entryIds": entries
               ]
               
        let jsonData = (try? JSONSerialization.data(withJSONObject: json))!
        URLSession.shared.dataTask(with: postRequest(url: (Constants.FEEDLY_HOST + Constants.MARK_READ_URL), jsonData: jsonData)) { data, response, error in
                   guard let data = data, error == nil else {
                       print(error?.localizedDescription ?? "No data")
                       return
                   }
                   do {
                       let res = try JSONDecoder().decode(ProfileResponse.self, from: data)
                       print(res)
                   } catch let error {
                       print(error)
                   }
                   
               }.resume()
        
    }
    
    func getStream(ranked: String, pageSize: Int, unreadOnly: Bool = true) {
      
        let queryItems = [URLQueryItem(name: "unReadOnly", value: String(unreadOnly)), URLQueryItem(name: "count", value: String(pageSize)), URLQueryItem(name: "ranked", value: ranked)]
        var urlComps = URLComponents(string: Constants.FEEDLY_HOST + Constants.STREAMS_URL)!
        urlComps.queryItems = queryItems
        let url = urlComps.url!
        
        URLSession.shared.dataTask(with: getRequest(url: url.absoluteString)) { data, response, error in
                   guard let data = data, error == nil else {
                       print(error?.localizedDescription ?? "No data")
                       return
                   }
                   do {
                       let res = try JSONDecoder().decode(StreamResponse.self, from: data)
                     
                       print(res)
                   } catch let error {
                       print(error)
                   }
                   
               }.resume()
        
    }
    
    func getProfile() {
        URLSession.shared.dataTask(with: getRequest(url: Constants.FEEDLY_HOST + Constants.PROFILE_URL)) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                let res = try JSONDecoder().decode(ProfileResponse.self, from: data)
                print(res)
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
    
}
