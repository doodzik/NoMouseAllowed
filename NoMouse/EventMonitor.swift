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
    
    func start(mask: Setting) {
        events[mask] = NSEvent.addGlobalMonitorForEvents(matching: mask.eventMask, handler: penalty) as AnyObject
    }
    
    func stop(mask: Setting) {
        if let event = events[mask] {
            NSEvent.removeMonitor(event)
            events.removeValue(forKey: mask)
        }
    }
    
    func penalty (_ event: NSEvent) {
        self.monitors.decrement()
        if let timer = self.timer {
            timer.invalidate()
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { _ in
            self.monitors.restore()
        }
        RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
    }

}
