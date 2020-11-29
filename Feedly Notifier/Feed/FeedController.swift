//
//  FeedController.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 20 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Cocoa

class FeedController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, FeedDataDelegate {
    var feedApi: FeedApi!
    
    @IBOutlet weak var feedlyWebButton: NSButton!
    @IBOutlet weak var lastUpdatedLabel: NSTextField!
    @IBOutlet weak var markAllAsReadButton: NSButton!
    @IBOutlet weak var refreshButton: NSButton!
    @IBOutlet weak var settingsButton: NSButton!
    @IBOutlet weak var feedTableView: NSTableView!
    
    @IBOutlet weak var settingsMenu: NSMenu!
    
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    var lastUpdatedDate : Date?
    var streamResponse: StreamResponse?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        print("Feed controller loaded")
        self.feedApi = FeedApi(feedDataDelegate: self)
       // self.feedApi.getCategories()
       // self.feedApi.getProfile()
        self.feedApi.getUnreadCounts()
        getStream()
       
    }
    
    override func viewWillAppear() {
        self.lastUpdatedLabel.stringValue = lastUpdatedDate?.timeAgoSinceDate() ?? ""
    }
    
    override var nibName : String {
        return "FeedController"
    }
    
    // MARK: button methods
    @IBAction func feedlyWebsiteButton(_ sender: NSButton) {
        let url = URL(string:"https://www.feedly.com")!
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func markAllAsReadButton(_ sender: NSButton) {
        var entryIds:[String] = []
        for entry in streamResponse?.items ?? [] {
            entryIds.append(entry.id)
        }
        if (entryIds.count > 0) {
            feedApi.markRead(entries: entryIds)
        }
    }
    
    @IBAction func refreshButton(_ sender: NSButton) {
        refreshFeed()
    }
    
    @IBAction func settingsButton(_ sender: NSButton) {
        
        let delegate = NSApplication.shared.delegate as! AppDelegate
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "About", action: #selector(delegate.openAboutLink), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Settings", action: #selector(delegate.showSettings), keyEquivalent: "s"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(delegate.quit), keyEquivalent: "q"))
        NSMenu.popUpContextMenu(menu, with: NSApp.currentEvent!, for: sender)
    }
    // MARK: Table data source methods
    func numberOfRows(in tableView: NSTableView) -> Int {
        return streamResponse?.items.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
        return false
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        print(row)
        return FeedCell.view(tableView, owner: self, subject: (streamResponse?.items[row])!)
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return true
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let table = notification.object as? NSTableView else {
                   return
               }
               let row = table.selectedRow
        if let url = streamResponse?.items[row].alternate?.first?.href {
            let url = URL(string:url)!
            NSWorkspace.shared.open(url)
            feedApi.markRead(entries: [(streamResponse?.items[row].id)!])
              let delegate = NSApplication.shared.delegate as! AppDelegate
            delegate.closePopover(sender: self)
        }
    }
   
    
    //    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
    //        return source.isGroup(atIndex: row) ? 45 : tableView.rowHeight
    //    }
    
    
    
    // MARK: Delegate methods
    func feedDataUpdated(streamResponse: StreamResponse) {
        self.streamResponse = streamResponse
        self.feedTableView.reloadData()
        self.lastUpdatedDate = Date.init()
        self.lastUpdatedLabel.stringValue = lastUpdatedDate?.timeAgoSinceDate() ?? ""
        self.progressIndicator.isHidden = true
        
    }
    
    func tokenRefreshed() {
        refreshFeed()
    }
    
    func updateCounts(countsResponse: CountsResponse) {
        var count: Int = 0
        for entry in countsResponse.unreadcounts {
            count = count + entry.count
        }
        updateIconText(count: count)
    }

    
    func feedDataMarkedRead() {
       refreshFeed()
    }
    
    func refreshFeed() {
        getStream()
        self.progressIndicator.isHidden = false
    }
    
    func getStream() {
        self.feedApi.getStream(ranked: Ranking.NEWEST, pageSize: 20)
        self.feedApi.getUnreadCounts()
    }
    
    func updateIconText(count: Int) {
         let delegate = NSApplication.shared.delegate as! AppDelegate
        delegate.setIconText(text: String(count))
    }
    
    
}
