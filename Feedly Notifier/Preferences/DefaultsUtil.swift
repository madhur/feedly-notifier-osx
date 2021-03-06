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
        DefaultsUtil.userDefault.set(value, forKey: key)
    }
    
    func save(key: String, value: Bool) {
        DefaultsUtil.userDefault.set(value, forKey: key)
    }
    
    func save (key: String, value: Int) {
        DefaultsUtil.userDefault.set(value, forKey: key)
    }
    
    
    func get(key: String) -> String? {
        return DefaultsUtil.userDefault.string(forKey: key)
    }
    
    class func defaults() -> DefaultsUtil {
          return singleton
    }
    
    func clearPreferences() {
    
    }
    func registerDefaults() {
        DefaultsUtil.userDefault.register(defaults: [
            DefaultKeys.SHOW_COUNTS: true,
            DefaultKeys.MARK_READ_OPEN: true,
            DefaultKeys.SORTING_METHOD:0
        ])
    }
//    func saveDefaults() {
//        DefaultsUtil.userDefault.set(DefaultValues.START_STARTUP, forKey: DefaultKeys.START_STARTUP)
//        DefaultsUtil.userDefault.set(DefaultValues.SHOW_COUNTS, forKey: DefaultKeys.SHOW_COUNTS)
//        DefaultsUtil.userDefault.set(DefaultValues.MARK_READ_OPEN, forKey: DefaultKeys.MARK_READ_OPEN)
//        DefaultsUtil.userDefault.set(DefaultValues.SORTING_METHOD, forKey: DefaultKeys.SORTING_METHOD)
//        DefaultsUtil.userDefault.set(DefaultValues.SHOW_SITE_ICON, forKey: DefaultKeys.SHOW_SITE_ICON)
//        DefaultsUtil.userDefault.set(DefaultValues.SELECTED_CATEGORIES, forKey: DefaultKeys.SELECTED_CATEGORIES)
//    }
    
    func getStartupSetting() -> Bool {
        return DefaultsUtil.userDefault.bool(forKey: DefaultKeys.START_STARTUP)
    }
    
    func getShowCountSetting() -> Bool {
          let showCount =  DefaultsUtil.userDefault.bool(forKey: DefaultKeys.SHOW_COUNTS)
          return showCount
    }
    
    func getMarkReadSetting() -> Bool {
        return DefaultsUtil.userDefault.bool(forKey: DefaultKeys.MARK_READ_OPEN)
    }
    
    func getSortingMethodSetting() -> Int {
        return DefaultsUtil.userDefault.integer(forKey: DefaultKeys.SORTING_METHOD)
    }    
    
    func getSelectedCategoriesSetting() -> Bool {
        return DefaultsUtil.userDefault.bool(forKey: DefaultKeys.SELECTED_CATEGORIES)
    }
    
    func saveSelectedCategories(categoryList: [CategoryList]) {
        let encoder = JSONEncoder()
        if let categoryListEncoded = try? encoder.encode(categoryList) {
           
            DefaultsUtil.userDefault.set(categoryListEncoded, forKey: DefaultKeys.CATEGORIES_LIST)
        }
    }
    
    func getSelectedCategories() -> [CategoryList]? {
        if let savedCategoryList = DefaultsUtil.userDefault.object(forKey: DefaultKeys.CATEGORIES_LIST) as? Data {
            let decoder = JSONDecoder()
            if let decodedCategoryList = try? decoder.decode([CategoryList].self, from: savedCategoryList) {
               return decodedCategoryList
            }
        }
        return nil
    }
    
}
