//
//  EventMonitor.swift
//  NoMouse
//
//  Created by frederik dudzik on 26.09.17.
//  Copyright © 2017 frederik dudzik. All rights reserved.
//

import Foundation
import Cocoa

extension NSEvent.EventTypeMask : Hashable {
    public var hashValue: Int {
        return Int(rawValue)
    }
}

public func ==(lhs: NSEvent.EventTypeMask, rhs: NSEvent.EventTypeMask) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

class EventMonitor {
    
    private var monitor: AnyObject?
    
    var monitors = Monitors()
    var timer: Timer?
    var events: [NSEvent.EventTypeMask: AnyObject] = [:]
    var harsh: Bool = false {
        didSet {
            monitors.decrementMultiplier = harsh ? 4 : 1
        }
    }
    
    func penalty (_ event: NSEvent) {
        self.monitors.decrement()
        if let timer = self.timer {
            timer.invalidate()
        }
        // 6 seconds later
        self.timer = Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false) { (timer) in
            self.monitors.restore()
        }
        RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
    }
    
    func start(mask: NSEvent.EventTypeMask) {
        switch mask {
        case .scrollWheel:
            events[.scrollWheel] = NSEvent.addGlobalMonitorForEvents(matching: .scrollWheel, handler: penalty) as AnyObject
        case .mouseMoved:
            events[.mouseMoved] = NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved, handler: penalty) as AnyObject
        case .leftMouseDown:
            events[.leftMouseDown] = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown, handler: penalty) as AnyObject
        default:
            fatalError("mask not implemented")
        }
    }
    
    func stop(mask: NSEvent.EventTypeMask) {
        if let event = events[mask] {
            NSEvent.removeMonitor(event)
            events.removeValue(forKey: mask)
        }
    }
}
