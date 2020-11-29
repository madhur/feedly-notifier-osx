//
//  PHPreferencesWindowControllerProtocol.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 25 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import AppKit

@objc protocol PreferencesWindowControllerProtocol {

    func preferencesIdentifier() -> String

    func preferencesTitle() -> String

    func preferencesIcon() -> NSImage

    @objc optional func firstResponder() -> NSResponder

    @objc optional func preferencesToolTip() -> String
}
