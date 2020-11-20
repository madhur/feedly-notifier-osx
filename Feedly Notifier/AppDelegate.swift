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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        // Do not display on dock
        NSApp.setActivationPolicy(NSApplication.ActivationPolicy.accessory)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

