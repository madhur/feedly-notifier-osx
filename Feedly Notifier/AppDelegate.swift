//
//  AppDelegate.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 19 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem  = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var feedlyWebWindowController: FeedlyWebWindowController!
    var feedController: FeedController!
    var popover: NSPopover!
    var aboutWindowController: AboutWindowController?
    var preferencesWindowController: PreferencesWindowController = PreferencesWindowController()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        // Do not display on dock
        NSApp.setActivationPolicy(NSApplication.ActivationPolicy.accessory)
       
        if  DefaultsUtil.defaults().get(key: DefaultKeys.ACCESS_TOKEN) != nil {
            self.popover = NSPopover()
            self.feedController = FeedController()
            self.popover.contentViewController = feedController
            self.popover.animates = false
            self.popover.behavior = .transient
        }
        else {
            statusItem.menu = statusMenu
        }
        
        if let button = self.statusItem.button {
          
            button.image = NSImage(named: "StatusBarIcon")
            button.imagePosition = .imageLeft
            //button.image = NSImage(named: NSImage.Name("ExampleMenuBarIcon"))
            button.action = #selector(togglePopover(_:))
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func startAuth(sender: NSMenuItem) {
        self.feedlyWebWindowController = FeedlyWebWindowController()
        self.feedlyWebWindowController.showWindow(self)
    }
    
    @objc func togglePopover(_ sender: NSStatusItem) {
        if self.popover.isShown {
            closePopover(sender: sender)
        }
        else {
            showPopover(sender: sender)
        }
        
    }
    
    func showPopover(sender: Any?) {
        if let button = self.statusItem.button {
            self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: Any?) {
        self.popover.performClose(sender)
    }
    
    @objc func openAboutLink() {
        self.aboutWindowController = AboutWindowController()
        aboutWindowController?.showWindow(self)
    }
    
    @objc  
    func showSettings() {
      
        self.preferencesWindowController.viewControllers = [ GeneralPreferencesViewController(nibName: "GeneralPreferences", bundle: nil), AdvancedPreferencesViewController(nibName: "AdvancedPreferences", bundle: nil) ]

              self.preferencesWindowController.showPreferencesWindow()
        self.preferencesWindowController.showWindow(self)
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(self)
    }
    
    @objc func setIconText(text: String) {
          if let button = self.statusItem.button {
                  
            button.title = text
        }
    }
}

