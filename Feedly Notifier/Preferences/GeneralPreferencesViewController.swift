//
//  GeneralPreferencesViewController.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 25 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Foundation
import Cocoa


class GeneralPreferencesViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, PreferencesWindowControllerProtocol, FeedGeneralSettingsDataDelegate {
    
    
    var categoriesResponse: [CategoryList]?
    var feedApi: FeedApi!
    
    @IBOutlet weak var startupCheckBox: NSButton!
    
    @IBOutlet weak var showCountsCheckBox: NSButton!
    
    @IBOutlet weak var markAsReadCheckBox: NSButton!
    
    @IBOutlet weak var sortingMethodComboBox: NSComboBox!
    
    @IBOutlet weak var updateCategoriesCheckBox: NSButton!
    @IBOutlet weak var showFavIconCheckBox: NSButton!
    
    @IBOutlet weak var categoriesTableView: NSTableView!
    
    @IBOutlet weak var categoryCheckBox: NSButtonCell!
    
    func preferencesIdentifier() -> String {
        return "GeneralPreferences"
    }
    
    func preferencesTitle() -> String {
        return "General"
    }
    
    func preferencesIcon() -> NSImage {
        return NSImage(named: NSImage.preferencesGeneralName)!
    }
    
    override func viewDidLoad() {
        self.feedApi = FeedApi(feedGeneralSettingsDataDelegate: self)
        sortingMethodComboBox.selectItem(at: DefaultsUtil.defaults().getSortingMethodSetting())
        
        self.feedApi.getCategories()
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
        DefaultsUtil.defaults().save(key: DefaultKeys.SORTING_METHOD, value: sortingMethodComboBox.indexOfSelectedItem)
    }
    
    @IBAction func showFavIconClicked(_ sender: Any) {
    }
    
    
    @IBAction func updateCategoriesClicked(_ sender: Any) {
    }
    
    //MARK: Table delgate methods
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.categoriesResponse?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
        
        var result = self.categoriesResponse?[row].selected
        self.categoriesResponse?[row].selected = !result!
        categoriesTableView.reloadData()
        print(row)
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if(tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "check")) {
            let cell = NSButtonCell()
            cell.identifier = tableColumn?.identifier
            return self.categoriesResponse?[row].selected
        }
        else if (tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "category")) {
            let cell = NSTextField()
            cell.identifier = tableColumn?.identifier
            cell.stringValue = self.categoriesResponse?[row].label ?? ""
            return self.categoriesResponse?[row].label
        }
        print(tableColumn!.identifier.rawValue + " " + (tableColumn?.identifier.rawValue)!)
        
        return nil
        
    }
    
    func categoriesFetched(categoriesResponse: [CategoryResponse]) {
        print(categoriesResponse)
        var categoryList : [CategoryList] = []
        for item in categoriesResponse {
            categoryList.append(CategoryList(id: item.id, label: item.label, created: item.created))
        }
        self.categoriesResponse = categoryList
        
        self.categoriesTableView.reloadData()
    }
    
    
    @IBAction func categorySelected(_ sender: NSButtonCell) {
        print("category selected")      
    }
}
