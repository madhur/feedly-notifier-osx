//
//  GeneralPreferencesViewController.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 25 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Foundation
import Cocoa


class GeneralPreferencesViewController: NSViewController, PreferencesWindowControllerProtocol {
    func preferencesIdentifier() -> String {
        return "GeneralPreferences"
    }
    
    func preferencesTitle() -> String {
        return "General"
    }
    
    func preferencesIcon() -> NSImage {
        return NSImage(named: NSImage.preferencesGeneralName)!
    }
    
    
}
