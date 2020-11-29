//
//  ErrorResponse.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 29 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let errorCode: Int
    let errorId: String
    let errorMessage: String
}
