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
    
    @IBOutlet weak var feedLoadingView: FeedLoadingView!
    
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
       updateLastUpdatedLabel()
    }
    
    override var nibName : String {
        return "FeedController"
    }
    
    // MARK: button methods
    @IBAction func feedlyWebsiteButton(_ sender: NSButton) {
        let url = URL(string: Constants.FEEDLY_WEB)!
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func markAllAsReadButton(_ sender: NSButton) {
        var entryIds:[String] = []
        for entry in streamResponse?.items ?? [] {
            entryIds.append(entry.id)
        }
        if (entryIds.count > 0) {
            feedApi.markRead(entries: entryIds, loadMoreData: true)
        }
    }
    
    @IBAction func refreshButton(_ sender: NSButton) {
        refreshFeed()
    }
    
    @IBAction func settingsButton(_ sender: NSButton) {
        
        let delegate = NSApplication.shared.delegate as! AppDelegate
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: Constants.SETTINGS, action: #selector(delegate.showSettings), keyEquivalent: "s"))
              menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: Constants.ABOUT, action: #selector(delegate.openAboutLink), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
      
        menu.addItem(NSMenuItem(title: Constants.QUIT, action: #selector(delegate.quit), keyEquivalent: "q"))
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
        if row == -1 {
            return
        }
        if let url = streamResponse?.items[row].alternate?.first?.href {
            let url = URL(string:url)!
            NSWorkspace.shared.open(url)
            if (DefaultsUtil.defaults().getMarkReadSetting()) {
                feedApi.markRead(entries: [(streamResponse?.items[row].id)!], loadMoreData: false)
                self.streamResponse?.items.remove(at: row)
                self.feedTableView.removeRows(at: IndexSet.init(integer: row), withAnimation: .slideRight)                            
            }

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
        updateLastUpdatedLabel()
        //self.progressIndicator.isHidden = true
        self.feedLoadingView.state = .idle
        
    }
    
 
    func tokenRefreshed() {
        refreshFeed()
    }
    
    func updateLastUpdatedLabel() {
        if let updated = lastUpdatedDate?.timeAgoSinceDate() {
                    self.lastUpdatedLabel.stringValue = "Last Updated: \(updated)"
               }
               else {
                   self.lastUpdatedLabel.stringValue = ""
               }
    }
    
    func updateCounts(countsResponse: CountsResponse) {
        var count: Int = 0
        var index: Int = 0
        for entry in countsResponse.unreadcounts {
            count = count + entry.count
            index = index + 1
        }
        print("Processed counts: " + String(index))
        updateIconText(count: count)
    }

    
    func feedDataMarkedRead(loadMoreData: Bool) {
        if (loadMoreData) {
            refreshFeed()
        }
    }
    
    func refreshFeed() {
        getStream()
        //self.progressIndicator.isHidden = false
        self.feedLoadingView.state = .loading
    }
    
    func getStream() {
      
        self.feedApi.getStream(ranked: DefaultsUtil.defaults().getSortingMethodSetting(), pageSize: Constants.PAGE_SIZE)
        self.feedApi.getUnreadCounts()
    }
    
    func updateIconText(count: Int) {
         let delegate = NSApplication.shared.delegate as! AppDelegate
         delegate.setIconText(text: String(count))
    }
    
    
}
