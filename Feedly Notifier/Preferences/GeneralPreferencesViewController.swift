//
//  GeneralPreferencesViewController.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 25 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Foundation
import Cocoa


class GeneralPreferencesViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, PreferencesWindowControllerProtocol {
    
    @IBOutlet weak var startupCheckBox: NSButton!
    
    @IBOutlet weak var showCountsCheckBox: NSButton!
    
    @IBOutlet weak var markAsReadCheckBox: NSButton!
    
    @IBOutlet weak var sortingMethodComboBox: NSComboBox!
    
    @IBOutlet weak var updateCategoriesCheckBox: NSButton!
    @IBOutlet weak var showFavIconCheckBox: NSButton!
    
    @IBOutlet weak var categoriesTableView: NSTableView!
    
    func preferencesIdentifier() -> String {
        return "GeneralPreferences"
    }
    
    func preferencesTitle() -> String {
        return "General"
    }
    
    func preferencesIcon() -> NSImage {
        return NSImage(named: NSImage.preferencesGeneralName)!
    }
    
    
    @IBAction func startupClicked(_ sender: NSButton) {
    }
    
    @IBAction func showCountsClicked(_ sender: Any) {
        if(showCountsCheckBox.state == NSControl.StateValue.on) {
            DefaultsUtil.defaults().save(key: DefaultKeys.SHOW_COUNTS, value: true)
        
        }
        else {
            DefaultsUtil.defaults().save(key: DefaultKeys.SHOW_COUNTS,  value: false)
        }
        
        let delegate = NSApplication.shared.delegate as! AppDelegate
        delegate.updateIconText()
    }
    
    @IBAction func markAsReadClicked(_ sender: Any) {
        if (markAsReadCheckBox.state == NSControl.StateValue.on) {
            DefaultsUtil.defaults().save(key: DefaultKeys.MARK_READ_OPEN, value: true)
        }
        else {
            DefaultsUtil.defaults().save(key: DefaultKeys.MARK_READ_OPEN, value: false)
        }
    }
    
    @IBAction func sortingMethodChanged(_ sender: NSComboBox) {
    }
    
    @IBAction func showFavIconClicked(_ sender: Any) {
    }
    
    
    @IBAction func updateCategoriesClicked(_ sender: Any) {
    }
}
