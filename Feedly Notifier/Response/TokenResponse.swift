//
//  TokenResponse.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 20 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Foundation

struct TokenResponse: Codable {
    let refresh_token: String
    let expires_in: Int
    let id: String
    let token_type: String
    let scope: String
    let provider: String
    let plan: String
    let access_token: String
}
