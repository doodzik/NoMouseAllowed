//
//  AppDelegate.swift
//  BackgroundLauncher
//
//  Created by frederik dudzik on 27.09.17.
//  Copyright © 2017 frederik dudzik. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        let mainAppIdentifier = "co.dudzik.NoMouse"

        if !NSRunningApplication.runningApplications(withBundleIdentifier: mainAppIdentifier).isEmpty {
            NSApp.terminate(nil)
            return
        }

        let launcherURL = Bundle.main.bundleURL
        let appURL = launcherURL.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()

        try! NSWorkspace.shared.launchApplication(at: appURL, options: .default, configuration: [:])
        NSApp.terminate(nil)
    }
    
}
