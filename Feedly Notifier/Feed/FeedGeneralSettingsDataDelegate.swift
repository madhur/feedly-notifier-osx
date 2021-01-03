//
//  FeedSettingsDataDelegate.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 3 January 2021.
//  Copyright © 2021 Madhur Ahuja. All rights reserved.
//

import Foundation

protocol FeedGeneralSettingsDataDelegate: class {
    
    func categoriesFetched(categoriesResponse: [CategoryResponse])
   
}
