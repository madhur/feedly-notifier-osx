//
//  Constants.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 20 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Foundation

struct Constants {
    
    static let FEEDLY_HOST = "https://sandbox7.feedly.com"
    static let AUTH_URL = "/v3/auth/auth?response_type=code&client_id=sandbox&scope=https://cloud.feedly.com/subscriptions&redirect_uri=" + REDIRECT_URI
    static let API_KEY = "HFoDWzLMxtSMFM3FJNgT4gdBIacC3Gm2"
    static let TOKEN_AUTH_URL = "/v3/auth/token"
    static let CATEGORIES_URL = "/v3/categories"
    static let PROFILE_URL = "/v3/profile"
    static let COUNTS_URL = "/v3/markers/counts"
    static let MARK_READ_URL = "/v3/markers"
    static let STREAMS_URL = "/v3/streams"
    static let CODE_URL = REDIRECT_URI + "/?code="
    static let REDIRECT_URI = "http://localhost"
    static let PAGE_SIZE = 20
    
}

struct DefaultKeys {
    static let ACCESS_TOKEN = "access_token"
    static let REFRESH_TOKEN = "refresh_token"
}

struct Ranking {
    static let ENGAGEMENT = "engagement"
}
