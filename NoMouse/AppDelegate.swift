//
//  AppDelegate.swift
//  NoMouse
//
//  Created by frederik dudzik on 26.09.17.
//  Copyright © 2017 frederik dudzik. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var menu: NSMenu!
    
    @IBOutlet weak var startAtLogin: NSMenuItem!
    @IBOutlet weak var harshPenalty: NSMenuItem!
    @IBOutlet weak var penalizeClick: NSMenuItem!
    @IBOutlet weak var penelizeMovement: NSMenuItem!
    @IBOutlet weak var penalizeScrolling: NSMenuItem!

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let defaults   = UserDefaults.standard

    var eventMonitor = EventMonitor()
    
    let START_AT_LOGIN_KEY    = "inBackground"
    let HARSH_PENALTY_KEY     = "harshPenalty"
    let PENALIZE_CLICK_KEY    = "penalizeClick"
    let PENALIZE_MOVEMENT_KEY = "penalizeMovement"
    let PENALIZE_SCROLL_KEY   = "penalizeScrolling"

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        /*
        let icon = NSImage(named: "Image")
        icon?.isTemplate = true
        statusItem.image = icon
        */
        statusItem.title = "NoMouse"
        statusItem.menu  = menu
        
        startAtLogin.state      = (defaults.bool(forKey: START_AT_LOGIN_KEY))    ? .on : .off
        harshPenalty.state      = (defaults.bool(forKey: HARSH_PENALTY_KEY))     ? .on : .off
        penalizeClick.state     = (defaults.bool(forKey: PENALIZE_CLICK_KEY))    ? .on : .off
        penelizeMovement.state  = (defaults.bool(forKey: PENALIZE_MOVEMENT_KEY)) ? .on : .off
        penalizeScrolling.state = (defaults.bool(forKey: PENALIZE_SCROLL_KEY))   ? .on : .off
     
        if defaults.bool(forKey: PENALIZE_CLICK_KEY) {
            eventMonitor.start(mask: .leftMouseDown)
        }
        
        if defaults.bool(forKey: PENALIZE_SCROLL_KEY) {
            eventMonitor.start(mask: .scrollWheel)
        }
        
        if defaults.bool(forKey: PENALIZE_MOVEMENT_KEY) {
            eventMonitor.start(mask: .mouseMoved)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    @IBAction func toggleStartAtLogin(_ sender: NSMenuItem) {
        toggle(sender, forKey: HARSH_PENALTY_KEY,
               on:  { startInBackground(true) },
               off: { startInBackground(false)})
    }
    
    @IBAction func toggleHarshPenalty(_ sender: NSMenuItem) {
        toggle(sender, forKey: HARSH_PENALTY_KEY,
               on:  {self.eventMonitor.harsh = true},
               off: {self.eventMonitor.harsh = false})
    }
    
    @IBAction func togglePenalizeClick(_ sender: NSMenuItem) {
        toggle(sender, forKey: PENALIZE_CLICK_KEY,
               on:  {eventMonitor.start(mask: .leftMouseDown)},
               off: {eventMonitor.stop(mask: .leftMouseDown)})
    }
    
    @IBAction func togglePenalizeMovement(_ sender: NSMenuItem) {
        toggle(sender, forKey: PENALIZE_MOVEMENT_KEY,
               on: {eventMonitor.start(mask: .mouseMoved)},
               off: {eventMonitor.start(mask: .mouseMoved)})
    }
    
    @IBAction func togglePenalizeScrolling(_ sender: NSMenuItem) {
        toggle(sender, forKey: PENALIZE_SCROLL_KEY,
               on:  {eventMonitor.start(mask: .scrollWheel)},
               off: {eventMonitor.stop(mask: .scrollWheel)})
    }
    
    @IBAction func quit(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    func toggle (_ sender: NSMenuItem, forKey: String, on: () -> () = {}, off: () -> () = {}) {
        if sender.state == .on {
            sender.state = .off
            defaults.set(false, forKey: forKey)
            off()
        } else {
            sender.state = .on
            defaults.set(true, forKey: forKey)
            on()
        }
    }
    
    func startInBackground(_ value: Bool) {
        let launcherAppIdentifier = "co.dudzik.NoMouse.BackgroundLauncher"
        SMLoginItemSetEnabled(launcherAppIdentifier as CFString, value)
    }

}
