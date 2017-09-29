//
//  Setting.swift
//  NoMouse
//
//  Created by frederik dudzik on 27.09.17.
//  Copyright © 2017 frederik dudzik. All rights reserved.
//

import Foundation
import Cocoa

enum Setting: String {
    case startAtLogin      = "inBackground"
    case harshPenalty      = "harshPenalty"
    case penalizeClick     = "penalizeClick"
    case penalizeMovement  = "penalizeMovement"
    case penalizeScrolling = "penalizeScrolling"
    
    var state: NSControl.StateValue {
        return UserDefaults.standard.bool(forKey: rawValue) ? .on : .off
    }
    
    var eventMask: NSEvent.EventTypeMask {
        switch self {
        case .penalizeClick:
            return .leftMouseDown
        case .penalizeMovement:
            return .mouseMoved
        case .penalizeScrolling:
            return .scrollWheel
        default:
            fatalError("\(rawValue) setting enum: EventTypeMask not implemented")
        }
    }
    
    func change(to: NSControl.StateValue) {
        let isOn = to == .on
        UserDefaults.standard.set(isOn, forKey: rawValue)
    }

}
