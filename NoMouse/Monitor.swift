//
//  Monitor.swift
//  NoMouse
//
//  Created by frederik dudzik on 26.09.17.
//  Copyright © 2017 frederik dudzik. All rights reserved.
//

import Foundation

class Monitor {
    
    let key = kIODisplayBrightnessKey as CFString
    var service: io_object_t
    
    init(service: io_object_t) {
        self.service = service
    }
    
    deinit {
        IOObjectRelease(service)
    }
    
    func set(brightness: Float) {
        let level = fmin(1.0, fmax(0.0, brightness))
        IODisplaySetFloatParameter(service, 0, key, level)
    }
    
    func getBrightness() -> Float {
        var level: Float = 0
        IODisplayGetFloatParameter(service, 0, key, &level)
        return level
    }
    
    
    func change(by delta: Float) {
        let brightness = getBrightness() + delta
        set(brightness: brightness)
    }
}
