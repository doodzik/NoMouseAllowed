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

    // MARK: Properties
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var eventMonitor = EventMonitor()
    
    // MARK: Outlets
    
    @IBOutlet weak var menu: NSMenu!
    
    @IBOutlet weak var startAtLogin:      NSMenuItem! {
        didSet {
            startAtLogin.state = Setting.startAtLogin.state
        }
    }
    @IBOutlet weak var harshPenalty:      NSMenuItem! {
        didSet {
            harshPenalty.state = Setting.harshPenalty.state
            eventMonitor.harsh = harshPenalty.state == .on
        }
    }
    @IBOutlet weak var penalizeClick:     NSMenuItem! {
        didSet {
            penalizeClick.state = Setting.penalizeClick.state
            if penalizeClick.state == .on {
                eventMonitorChange(state: .on, for: .penalizeClick)
            }
        }
    }
    @IBOutlet weak var penelizeMovement:  NSMenuItem! {
        didSet {
            penelizeMovement.state = Setting.penalizeMovement.state
            if penelizeMovement.state == .on {
                eventMonitorChange(state: .on, for: .penalizeMovement)
            }
        }
    }
    @IBOutlet weak var penalizeScrolling: NSMenuItem! {
        didSet {
            penalizeScrolling.state = Setting.penalizeScrolling.state
            if penalizeScrolling.state == .on {
                eventMonitorChange(state: .on, for: .penalizeScrolling)
            }
        }
    }
    
    // MARK: Lifecycle
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        /*
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true
        statusItem.image = icon
         */
        statusItem.title = "NoMouse"
        statusItem.menu  = menu
    }
    
    func applicationDidChangeScreenParameters(_ notification: Notification) {
        eventMonitor.resetScreens()
    }
    
    // MARK: Actions

    @IBAction func toggleStartAtLogin(_ sender: NSMenuItem) {
        let state = toggle(sender, for: .startAtLogin)
        startInBackground(state == .on)
    }
    
    @IBAction func toggleHarshPenalty(_ sender: NSMenuItem) {
        let state = toggle(sender, for: .harshPenalty)
        self.eventMonitor.harsh = state == .on
    }
    
    @IBAction func togglePenalizeClick(_ sender: NSMenuItem) {
        let state = toggle(sender, for: .penalizeClick)
        eventMonitorChange(state: state, for: .penalizeClick)
    }
    
    @IBAction func togglePenalizeMovement(_ sender: NSMenuItem) {
        let state = toggle(sender, for: .penalizeMovement)
        eventMonitorChange(state: state, for: .penalizeMovement)
    }
    
    @IBAction func togglePenalizeScrolling(_ sender: NSMenuItem) {
        let state = toggle(sender, for: .penalizeScrolling)
        eventMonitorChange(state: state, for: .penalizeScrolling)
    }
    
    @IBAction func quit(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    // MARK: Custom
    
    func toggle (_ sender: NSMenuItem, for setting: Setting) -> NSControl.StateValue {
        let state: NSControl.StateValue = sender.state == .on ? .off : .on
        sender.state = state
        setting.change(to: state)
        return state
    }
    
    func eventMonitorChange(state: NSControl.StateValue, for mask: Setting) {
        if state == .on {
            eventMonitor.start(mask: mask)
        } else {
            eventMonitor.stop(mask: mask)
        }
    }
    
    func startInBackground(_ value: Bool) {
        let launcherAppIdentifier = "co.dudzik.NoMouse.BackgroundLauncher"
        SMLoginItemSetEnabled(launcherAppIdentifier as CFString, value)
    }

}
