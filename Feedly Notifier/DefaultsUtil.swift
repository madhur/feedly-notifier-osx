//
//  DefaultsUtil.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 20 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Foundation

class DefaultsUtil {
    
    
    private static let userDefault  = UserDefaults.standard
    private static let singleton = DefaultsUtil()
    
    private init() {
    
    }
    
    func save(key: String, value: String) {
        DefaultsUtil.userDefault.set(key, forKey: value)
    }
    
    func get(key: String) -> String? {
        return DefaultsUtil.userDefault.string(forKey: key)
    }
    
    class func defaults() -> DefaultsUtil {
          return singleton
      }
    
}
