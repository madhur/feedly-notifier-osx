//
//  FeedDataDelegate.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 23 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Foundation

protocol FeedDataDelegate : class {
    
    func feedDataUpdated(streamResponse: StreamResponse)
    
    func feedDataMarkedRead()
    
    func updateCounts(countsResponse: CountsResponse)
}
