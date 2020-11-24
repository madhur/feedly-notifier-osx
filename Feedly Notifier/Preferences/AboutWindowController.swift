//
//  AboutWindowController.swift
//  Weather Pollution Bar
//
//  Created by Madhur Ahuja on 03 Jan.
//  Copyright © 2016 Madhur Ahuja. All rights reserved.
//

import Cocoa

class AboutWindowController: NSWindowController {

    @IBOutlet weak var homeButton: NSButton!
    
    @IBOutlet weak var twitterButton: NSButton!
    
    @IBOutlet weak var gitButton: NSButton!
    
    
    override var windowNibName: String
    {
            return "AboutWindow"
    }
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
       
       // progImage.image = NSImage(named: "statusIcon")
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

    }
    
    @IBAction func openHomepage(sender: AnyObject) {
        
        let  workspace = NSWorkspace()
        
        if sender as! NSObject == homeButton
        {
            workspace.open(NSURL(string: Constants.HOME_URL)! as URL)
        }
        else if sender as! NSObject == twitterButton
        {
            workspace.open(NSURL(string: Constants.TWITTER_URL)! as URL)
        }
        else if sender as! NSObject == gitButton
        {
            workspace.open(NSURL(string: Constants.GIT_URL)! as URL)
        }
        
    }
    
    @IBOutlet weak var versionText: NSTextField!
    @IBOutlet weak var progImage: NSImageView!
}
