//
//  PHTestSettingsViewController.swift
//  ProductHunt
//
//  Created by Vlado on 3/22/16.
//  Copyright © 2016 ProductHunt. All rights reserved.
//
// Taken from https://github.com/phranck/CCNPreferencesWindowController

import AppKit

let PHPreferencesToolbarIdentifier = "PreferencesMainToolbar"
let PHPreferencesWindowFrameAutoSaveName = "PreferencesWindowFrameAutoSaveName"
let PHPreferencesDefaultWindowRect = NSMakeRect(0, 0, 420, 230)
let escapeKey = 53

class PreferencesWindowController : NSWindowController, NSToolbarDelegate, NSWindowDelegate {

    fileprivate var toolbar: NSToolbar?
    fileprivate var toolbarDefaultItemIdentifiers = [NSToolbarItem.Identifier]()
    fileprivate var activeViewController: PreferencesWindowControllerProtocol?

    var viewControllers = [PreferencesWindowControllerProtocol]() {
        didSet {
            setupToolbar()
        }
    }

    init() {
        let masks: NSWindow.StyleMask = [.closable, .miniaturizable, .resizable, .fullScreen, .fullScreen]
        let window = PHPreferencesWindow(contentRect: PHPreferencesDefaultWindowRect, styleMask: masks, backing: .buffered, defer: true)

        window.isMovableByWindowBackground = true

        super.init(window: window)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

    func showPreferencesWindow() {
        guard let window = window, !window.isVisible else {
            return
        }

        showWindow(self)
        window.makeKeyAndOrderFront(self)
        NSApplication.shared.activate(ignoringOtherApps: true)

        if activeViewController == nil {
            activateViewController(viewControllers[0], animate:false)
            window.center()
        }
        
        if let toolbar = window.toolbar, toolbarDefaultItemIdentifiers.count > 0 {
           // toolbar.selectedItemIdentifier = NSToolbarItem.init(itemIdentifier: NSToolbarItem.id)
            //NSToolbarItem.Identifier(
            
            toolbar.selectedItemIdentifier = NSToolbarItem.init(itemIdentifier: toolbarDefaultItemIdentifiers.first!).itemIdentifier
            
        }
    }

    func dismissPreferencesWindow() {
        close()
    }

    fileprivate func setupToolbar() {
        guard let window = window else {
            return
        }

        window.toolbar = nil
        toolbar = nil
        toolbarDefaultItemIdentifiers.removeAll()

        if viewControllers.count > 0 {
            toolbar = NSToolbar(identifier: PHPreferencesToolbarIdentifier)

            toolbar?.allowsUserCustomization = true
            toolbar?.autosavesConfiguration = true

            toolbar?.delegate = self
            window.toolbar = toolbar
        }
    }

    fileprivate func activateViewController(_ viewController: PreferencesWindowControllerProtocol, animate: Bool) {
        if let preferencesViewController = viewController as? NSViewController {

            let viewControllerFrame = preferencesViewController.view.frame

            if  let currentWindowFrame = window?.frame,
                let frameRectForContentRect = window?.frameRect(forContentRect: viewControllerFrame) {

                let deltaY = NSHeight(currentWindowFrame) - NSHeight(frameRectForContentRect)
                let newWindowFrame = NSMakeRect(NSMinX(currentWindowFrame), NSMinY(currentWindowFrame) + deltaY, NSWidth(frameRectForContentRect), NSHeight(frameRectForContentRect))

                window?.title = viewController.preferencesTitle() as String

                let newView = preferencesViewController.view
                newView.frame.origin = NSMakePoint(0, 0)
                newView.alphaValue = 0.0
                newView.autoresizingMask = NSView.AutoresizingMask()

                if let previousViewController = activeViewController as? NSViewController {
                    previousViewController.view.removeFromSuperview()
                }

                window?.contentView!.addSubview(newView)

                if let firstResponder = viewController.firstResponder?() {
                    window?.makeFirstResponder(firstResponder)
                }

                NSAnimationContext.runAnimationGroup({
                    (context: NSAnimationContext) -> Void in
                    context.duration = (animate ? 0.25 : 0.0)
                    context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                    self.window?.animator().setFrame(newWindowFrame, display: true)
                    newView.animator().alphaValue = 1.0
                }) {
                    () -> Void in
                    self.activeViewController = viewController
                }
            }
        }
    }

    fileprivate func viewControllerWithIdentifier(_ identifier: NSString) -> PreferencesWindowControllerProtocol? {
        for viewController in viewControllers {
            if viewController.preferencesIdentifier() == identifier as String {
                return viewController
            }
        }

        return nil
    }
    
    // MARK: TOOLBAR methods
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        guard let viewController = viewControllerWithIdentifier(itemIdentifier as NSString) else {
            return nil
        }

        let identifier = viewController.preferencesIdentifier()
        let label = viewController.preferencesTitle()
        let icon = viewController.preferencesIcon()

        let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: identifier as String))
        toolbarItem.label = label
        toolbarItem.paletteLabel = label
        toolbarItem.image = icon
        if let tooltip = viewController.preferencesToolTip?() {
            toolbarItem.toolTip = tooltip
        }
        toolbarItem.target = self
        toolbarItem.action = #selector(PreferencesWindowController.toolbarItemAction(_:))

        return toolbarItem
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier]{
        var identifiers = [NSToolbarItem.Identifier]()

        for viewController in viewControllers {
            identifiers.append(NSToolbarItem.Identifier(rawValue: viewController.preferencesIdentifier()))
        }

        toolbarDefaultItemIdentifiers = identifiers

        return identifiers
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarDefaultItemIdentifiers(toolbar)
    }

    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarDefaultItemIdentifiers(toolbar)
    }

    @objc func toolbarItemAction(_ toolbarItem: NSToolbarItem) {
    
        guard let activeViewController = activeViewController, activeViewController.preferencesIdentifier() != toolbarItem.itemIdentifier.rawValue else {
            return
        }

        if let viewController = viewControllerWithIdentifier(toolbarItem.itemIdentifier as NSString) {
            activateViewController(viewController, animate: true)
        }
    }
}

class PHPreferencesWindow : NSWindow {

    override init(contentRect: NSRect, styleMask aStyle: NSWindow.StyleMask, backing bufferingType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, defer: flag)
        commonInit()
    }

    fileprivate func commonInit() {
        center()

        setFrameAutosaveName(PHPreferencesWindowFrameAutoSaveName)
        setFrame(from: PHPreferencesWindowFrameAutoSaveName)
    }

    override func keyDown(with theEvent: NSEvent) {
        switch Int(theEvent.keyCode) {

        case escapeKey:
            orderOut(nil)
            close()

        default:
            super.keyDown(with: theEvent)
        }
    }

}
