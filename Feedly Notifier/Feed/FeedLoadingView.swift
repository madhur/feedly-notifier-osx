//
//  FeedLoadingView.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 2 January 2021.
//  Copyright © 2021 Madhur Ahuja. All rights reserved.
//

import Cocoa

enum LoadingState {
    case loading, error, empty, idle
}

class FeedLoadingView: NSView {

    @IBOutlet weak var loadingIndicator: NSProgressIndicator!
    @IBOutlet weak var loadingLabel: NSTextField!
    
    override func viewWillDraw() {
        loadingLabel.appearance = NSAppearance(named: NSAppearance.Name.aqua)
        //self.window?.isOpaque = false
    }
    

    var state: LoadingState = .idle {
        didSet {
            switch state {
            case .loading:
                isHidden = false
               // reload.isHidden = true
                loadingIndicator.isHidden = false
                loadingIndicator.startAnimation(nil)
                loadingLabel.stringValue = "Hunting down new feeds..."

            case .error:
                isHidden = false
               // reload.isHidden = false
                loadingIndicator.isHidden = true
                loadingIndicator.stopAnimation(nil)
                loadingLabel.stringValue = "Something went wrong 😿"

            case .empty:
                isHidden = false
              //  reload.isHidden = false
                loadingIndicator.isHidden = true
                loadingIndicator.stopAnimation(nil)
                loadingLabel.stringValue = "Nothing to show 😿"

            case .idle:
                isHidden = true
                loadingIndicator.stopAnimation(nil)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        wantsLayer = true
        layer?.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }

   
}
