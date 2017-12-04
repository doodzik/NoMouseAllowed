//
//  AppDelegate.swift
//  NoMouse
//
//  Created by frederik dudzik on 26.09.17.
//  Copyright © 2017 frederik dudzik. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let launcherURL = Bundle.main.bundleURL
        let launcherAppIdentifier = "co.dudzik.NoMouse.BackgroundLauncher"

        //if NSRunningApplication.runningApplications(withBundleIdentifier: launcherAppIdentifier).isEmpty {

            let exePath = launcherURL.appendingPathComponent("Contents")
                                     .appendingPathComponent("Library")
                                     .appendingPathComponent("LoginItems")
                                     .appendingPathComponent("BackgroundLauncher")
                                     .appendingPathExtension("app")
            try! NSWorkspace.shared.launchApplication(at: exePath, options: .default, configuration: [:])
        //}
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
