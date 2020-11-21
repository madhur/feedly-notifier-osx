//
//  FeedController.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 20 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Cocoa

class FeedController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    var feedApi: FeedApi!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        print("Feed controller loaded")
        self.feedApi = FeedApi()
        self.feedApi.getCategories()
        self.feedApi.getProfile()
        self.feedApi.getUnreadCounts()
    }
    
    override var nibName : String{
          return "FeedController"
      }

}
