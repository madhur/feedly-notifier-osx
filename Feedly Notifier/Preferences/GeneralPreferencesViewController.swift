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
    }
    
    @IBAction func markAsReadClicked(_ sender: Any) {
    }
    
    @IBAction func sortingMethodChanged(_ sender: NSComboBox) {
    }
    
    @IBAction func showFavIconClicked(_ sender: Any) {
    }
    
    
    @IBAction func updateCategoriesClicked(_ sender: Any) {
    }
}
