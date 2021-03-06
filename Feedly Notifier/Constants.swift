//
//  Constants.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 20 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Foundation

struct Constants {
    static let CLIENT_ID  = "sandbox"
    static let FEEDLY_HOST = "https://sandbox7.feedly.com"
    static let AUTH_URL = "/v3/auth/auth?response_type=code&client_id=sandbox&scope=https://cloud.feedly.com/subscriptions&redirect_uri=" + REDIRECT_URI
    static let API_KEY = "HFoDWzLMxtSMFM3FJNgT4gdBIacC3Gm2"
    static let TOKEN_AUTH_URL = "/v3/auth/token"
    static let CATEGORIES_URL = "/v3/categories"
    static let PROFILE_URL = "/v3/profile"
    static let COUNTS_URL = "/v3/markers/counts"
    static let MARK_READ_URL = "/v3/markers"
    static let STREAMS_URL = "/v3/streams/" + CATEGORY_VARIABLE + "/contents"
    
    static let USER_ID_VARIABLE = "{USER_ID}"
    static let CATEGORY_VARIABLE = "{CATEGORY}"
    static let SAVED_GROUP = "user/" + USER_ID_VARIABLE + "/tag/global.saved";
    static let GLOBAL_GROUP = "user/" + USER_ID_VARIABLE + "/category/global.all";
    static let GLOBAL_UNCATEGORIZED = "user/" + USER_ID_VARIABLE + "/category/global.uncategorized";
    static let GLOBAL_FAVORITES = "user/" + USER_ID_VARIABLE + "/category/global.must"
    
    static let CODE_URL = REDIRECT_URI + "/?code="
    static let REDIRECT_URI = "http://localhost"
    static let PAGE_SIZE = 20
    
    static let TWITTER_URL = "https://twitter.com/madhur25"
    static let GIT_URL = "https://github.com/madhur/feedly-notifier-osx"
    static let HOME_URL = "http://madhur.co.in"
    
    // UI Constants
    static let LAST_UPDATED = "Last Updated: "
    static let FEEDLY_WEB = "https://www.feedly.com"
    static let SETTINGS = "Settings"
    static let ABOUT = "About"
    static let QUIT = "Quit"
    static let UNKNOWN_TITLE = "Unknown Title"
    static let UNKNOWN_AUTHOR = "Unknown Author"

}

struct DefaultKeys {
    // MARK: implicit preferences
    static let ACCESS_TOKEN = "access_token"
    static let REFRESH_TOKEN = "refresh_token"
    static let USER_ID = "user_id"
    static let USER_NAME = "user_name"
    static let USER_EMAIL = "user_email"
    // MARK : general preferences
    static let START_STARTUP = "start_startup"
    static let SHOW_COUNTS = "show_counts"
    static let MARK_READ_OPEN = "mark_read_open"
    static let SORTING_METHOD = "ranking"
    static let SELECTED_CATEGORIES = "selected_categories"
    static let CATEGORIES_LIST = "categories_list"
}

struct DefaultValues {
    // MARK : general preferences  values
    static let START_STARTUP = false
    static let SHOW_COUNTS = true
    static let MARK_READ_OPEN = true
    static let SORTING_METHOD = "newest"
    static let SHOW_SITE_ICON = true
    static let SELECTED_CATEGORIES = false
    static let CATEGORIES_LIST = "categories_list"
}

enum Ranking: Int {
    case newest = 0, oldest, engagement
    
    func getRankingStr() -> String {
        switch self {
        case Ranking.newest:
            return "newest"
           
        case Ranking.oldest:
            return "oldest"
          
        case Ranking.engagement:
            return "engagement"
        
        }
    }
}
