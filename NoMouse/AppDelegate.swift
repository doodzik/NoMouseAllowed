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

    @IBOutlet weak var launchAtLoginOutlet: NSButton! {
        didSet {
            launchAtLoginOutlet.state = UserDefaults.standard.bool(forKey: "launchAtLogin") ? .on : .off
        }
    }
    
    let launcherAppIdentifier = "co.dudzik.NoMouse.BackgroundLauncher"
    let launcherURL = Bundle.main.bundleURL
    let bundleId = Bundle.main.bundleIdentifier

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if NSRunningApplication.runningApplications(withBundleIdentifier: launcherAppIdentifier).isEmpty {
            let exePath = launcherURL.appendingPathComponent("Contents")
                .appendingPathComponent("Library")
                .appendingPathComponent("LoginItems")
                .appendingPathComponent("BackgroundLauncher")
                .appendingPathExtension("app")
            try! NSWorkspace.shared.launchApplication(at: exePath, options: .default, configuration: [:])
        }
    }

    @IBAction func launchAtLogin(_ sender: NSButton) {
        let isOn = sender.state == .on
        SMLoginItemSetEnabled(launcherAppIdentifier as CFString, isOn)
        UserDefaults.standard.set(isOn, forKey: "launchAtLogin")
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
