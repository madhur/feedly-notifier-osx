//
//  RefreshTokenResponse.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 29 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Foundation

struct RefreshTokenResponse: Codable {
    let id: String
    let access_token: String
    let expires_in: Int
    let token_type: String
    let plan: String
}
