//
//  EventMonitor.swift
//  NoMouse
//
//  Created by frederik dudzik on 26.09.17.
//  Copyright © 2017 frederik dudzik. All rights reserved.
//

import Foundation
import Cocoa

class EventMonitor {
    
    let RESTAURATION_TIME_IN_SECONDS = 4.0

    var timer: Timer?
    var monitors = Monitors()
    var harsh: Bool = false {
        didSet {
            monitors.decrementMultiplier = harsh ? 4 : 1
        }
    }
    var events: [Setting: AnyObject] = [:]
    
    func resetScreens() {
        monitors = Monitors()
    }
    
    func start(setting: Setting) {
        events[setting] = NSEvent.addGlobalMonitorForEvents(matching: setting.eventMask, handler: penalty) as AnyObject
    }
    
    func stop(setting: Setting) {
        if let event = events[setting] {
            NSEvent.removeMonitor(event)
            events.removeValue(forKey: setting)
        }
    }
    
    func penalty (_ event: NSEvent) {
        self.monitors.decrement()
        if let oldTimer = timer {
            oldTimer.invalidate()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: RESTAURATION_TIME_IN_SECONDS, repeats: false) { _ in
            self.monitors.restore()
        }
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }

}
