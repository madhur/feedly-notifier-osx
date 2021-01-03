//
//  CategoryList.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 3 January 2021.
//  Copyright © 2021 Madhur Ahuja. All rights reserved.
//

import Foundation

struct CategoryList : Codable {
      let id: String
      let label: String
      let created: Int
      var selected: Bool
    
    init(id: String, label: String, created: Int) {
        self.id = id
        self.label = label
        self.created = created
        self.selected = true
    }
    init(id: String, label: String, created: Int, selected: Bool) {
        self.id = id
        self.label = label
        self.created = created
        self.selected = selected
    }
}
