//
//  ProfileResponse.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 21 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Foundation

struct ProfileResponse: Codable {
    let email: String
    let fullName: String
    let id: String
    let picture: String
}
