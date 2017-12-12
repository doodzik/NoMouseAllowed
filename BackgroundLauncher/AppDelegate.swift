//
//  AppDelegate.swift
//  BackgroundLauncher
//
//  Created by frederik dudzik on 27.09.17.
//  Copyright © 2017 frederik dudzik. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegateStatusBar: NSObject, NSApplicationDelegate {

    // MARK: Properties

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var eventMonitor = EventMonitor()

    // MARK: Outlets

    @IBOutlet weak var menu: NSMenu!

    @IBOutlet weak var harshPenalty: NSMenuItem! {
        didSet {
            harshPenalty.state = Setting.harshPenalty.state
            eventMonitor.harsh = harshPenalty.state == .on
        }
    }
    @IBOutlet weak var penalizeClick: NSMenuItem! {
        didSet {
            penalizeClick.state = Setting.penalizeClick.state
            if penalizeClick.state == .on {
                eventMonitorChange(state: .on, for: .penalizeClick)
            }
        }
    }
    @IBOutlet weak var penelizeMovement: NSMenuItem! {
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

        let mainBundleId = Bundle.main.bundleIdentifier!
        if !NSRunningApplication.runningApplications(withBundleIdentifier: mainBundleId).isEmpty {
            NSApplication.shared.terminate(self)
            return
        }

        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        statusItem.image = icon
        statusItem.title = ""
        statusItem.menu  = menu
    }

    func applicationDidChangeScreenParameters(_ notification: Notification) {
        eventMonitor.resetScreens()
    }

    // MARK: UI-Actions

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
    
    @IBAction func openAbout(_ sender: NSMenuItem) {
        let launcherURL = Bundle.main.bundleURL
        let appURL = launcherURL.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()

        try! NSWorkspace.shared.launchApplication(at: appURL, options: .default, configuration: [:])
    }

    @IBAction func quit(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    // MARK: Actions

    func toggle (_ sender: NSMenuItem, for setting: Setting) -> NSControl.StateValue {
        let state: NSControl.StateValue = sender.state == .on ? .off : .on
        sender.state = state
        setting.change(to: state)
        return state
    }

    func eventMonitorChange(state: NSControl.StateValue, for setting: Setting) {
        state == .on ? eventMonitor.start(setting: setting) : eventMonitor.stop(setting: setting)
    }

}
