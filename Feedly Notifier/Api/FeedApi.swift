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
    
}
