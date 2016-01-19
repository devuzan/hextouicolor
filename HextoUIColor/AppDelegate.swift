//
//  AppDelegate.swift
//  HextoUIColor
//
//  Created by Yusuf U. on 16/01/16.
//  Copyright © 2016 Yusuf U. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate,NSUserNotificationCenterDelegate{

    //MARK: - Properties.
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    var masterViewController: MasterViewController!
    
    //MARK: - IBOutlets.
    
    @IBOutlet weak var window: NSWindow!

    //MARK: - App methods.
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {

        if let button = statusItem.button{
            
            button.image = NSImage(named: "StatusBarIcon")
            button.action = Selector("showWindow:")

        }
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Show Window", action: Selector("showWindow:"), keyEquivalent: "s"))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Quit", action: Selector("quit:"), keyEquivalent: "q"))

        statusItem.menu = menu
        masterViewController = MasterViewController(nibName: "MasterViewController", bundle: nil)
        masterViewController.view.frame = (window.contentView! as NSView).bounds
        window.contentView?.addSubview(masterViewController.view)
        
        NSUserNotificationCenter.defaultUserNotificationCenter().delegate = self

    }

    func showWindow(sender: NSImage){
        
        self.window!.orderFront(self)        
        
    }
    
    
    func quit(sender: AnyObject){
        
        NSApp.terminate(self)
    
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        
        return true
        
    }

    func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    
        return true
        
    }
    
}

