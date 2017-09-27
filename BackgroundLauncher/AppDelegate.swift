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
        let path = NSWorkspace.shared.absolutePathForApplication(withBundleIdentifier: mainAppIdentifier)
        NSWorkspace.shared.launchApplication(path!)
        NSApplication.shared.terminate(self)
    }
    
}

