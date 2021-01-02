//
//  AdvancedPreferencesViewController.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 25 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Foundation
import Cocoa

class AdvancedPreferencesViewController: NSViewController, PreferencesWindowControllerProtocol {
    @IBOutlet weak var userNameTextField: NSTextField!
    @IBOutlet weak var emailTextField: NSTextField!
    
    @IBAction func logoutAction(_ sender: Any) {
        
    }
    
    func preferencesIdentifier() -> String {
        return "AdvancedPreferences"
    }
    
    func preferencesTitle() -> String {
        return "Advanced"
    }
    
    func preferencesIcon() -> NSImage {
        return NSImage(named: NSImage.advancedName)!
    }
    
    
}
