//
//  NoMouse.swift
//  NoMouse
//
//  Created by frederik dudzik on 26.09.17.
//  Copyright © 2017 frederik dudzik. All rights reserved.
//

import Foundation

class Monitors {
    let BRIGHTNESS_INCREMENT: Float = 0.015
    let BRIGHTNESS_DECREMENT: Float = -0.1
    var decrementMultiplier:  Float = 1
    
    var monitors = [Monitor]()
    
    var defaultBrightness: Float
    var brightness: Float {
        return monitors.first?.getBrightness() ?? 0.0
    }
    
    init() {
        var iterator: io_iterator_t = 0
        
        if IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"), &iterator) == kIOReturnSuccess {
            
            var service: io_object_t = 1
            
            while service != 0 {
                service     = IOIteratorNext(iterator)
                let monitor = Monitor(service: service)
                monitors.append(monitor)
            }
        }
        defaultBrightness = monitors.first?.getBrightness() ?? 0.0
    }
    
    func decrement() {
        change(by: BRIGHTNESS_DECREMENT * decrementMultiplier)
    }
    
    func restore() {
        while brightness < defaultBrightness {
            change(by: BRIGHTNESS_INCREMENT)
        }
        
        defaultBrightness = brightness
    }
    
    func change(by delta: Float) {
        for monitor: Monitor in monitors {
            monitor.change(by: delta)
        }
    }

}
