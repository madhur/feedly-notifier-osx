//
//  FeedlyMenuController.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 20 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Cocoa


class FeedlyMenuController: NSObject  {

    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem  = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var feedlyWebWindowController: FeedlyWebWindowController!
    
    override func awakeFromNib() {
        //statusItem.image = icon
        statusItem.title = "madhur"
        statusItem.menu = statusMenu
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func startAuth(sender: NSMenuItem) {
        self.feedlyWebWindowController = FeedlyWebWindowController()
        self.feedlyWebWindowController.showWindow(self)
    }

}
