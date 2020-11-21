//
//  CountsResponse.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 21 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Foundation

struct CountsResponse: Codable {
    let unreadcounts: [Feed]
    let updated: Int
}

struct Feed : Codable {
    let id: String
    let count: Int
    let updated: Int
}
