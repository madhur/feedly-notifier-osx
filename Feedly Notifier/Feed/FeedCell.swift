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
        view.authorLabel.stringValue = subject.origin?.title ?? Constants.UNKNOWN_AUTHOR
        view.postTitle.stringValue = subject.title ?? Constants.UNKNOWN_TITLE
        view.postTime.stringValue = getStringTimeFromPost(item: subject)
//        if let imageUrl = subject.visual?.url {
//            view.postImage.image = NSImage(byReferencing: URL(string: imageUrl)!)
//        }
        if let urlForImage = getUrlForImage(subject: subject) {
            FaviconFinder(url: urlForImage).downloadFavicon { result in
                       switch result {
                       case .success(let favicon):
                           print("URL of Favicon: \(favicon.url)")
                            view.postImage.image = favicon.image

                       case .failure(let error):
                           print("Error: \(error)")
                       }
                   }
            
        }
       
         return view
     }
    
    class func getStringTimeFromPost(item: Item) -> String {
        let interval = TimeInterval.init(exactly: item.crawled / 1000) ?? TimeInterval.init()
        return Date.init(timeIntervalSince1970:interval).timeAgoShort()
    }
    
    class func getUrlForImage(subject: Item) ->URL? {
        if let href = subject.alternate?.first?.href {
             return URL(string: href)
        }
       return nil
    }
}
