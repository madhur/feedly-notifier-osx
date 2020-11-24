//
//  FeedCell.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 21 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Cocoa

class FeedCell: NSTableCellView {

    @IBOutlet weak var authorLabel: NSTextField!
    @IBOutlet weak var postTitle: NSTextField!
    @IBOutlet weak var postTime: NSTextField!
    @IBOutlet weak var postImage: NSImageView!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    class func view(_ tableView: NSTableView, owner: AnyObject?, subject: Item) -> NSView {
        let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "feedCellIdentifier"), owner: owner) as! FeedCell
        view.authorLabel.stringValue = subject.origin?.title ?? "Uknown Author"
        view.postTitle.stringValue = subject.title ?? "Uknown Title"
        view.postTime.stringValue = getStringTimeFromPost(item: subject)
        if let imageUrl = subject.visual?.url {
            view.postImage.image = NSImage(byReferencing: URL(string: imageUrl)!)
        }
         return view
     }
    
    class func getStringTimeFromPost(item: Item) -> String {
        let interval = TimeInterval.init(exactly: item.crawled / 1000) ?? TimeInterval.init()
        return Date.init(timeIntervalSince1970:interval).timeAgoShort()
    }
}
