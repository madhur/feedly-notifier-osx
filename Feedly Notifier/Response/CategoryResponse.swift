//
//  CategoriesResponse.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 21 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Foundation

struct CategoryResponse : Codable {
    let id: String
    let label: String
    let created: Int
 
}
