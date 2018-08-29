//
//  WeatherSeverity.swift
//  BarelyRaining
//
//  Created by Nick Cracchiolo on 8/27/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

/// Enum describing the three values a WeatherAlert can use for the severity of the weather
enum WeatherSeverity {
    /// An individual should be aware of potentially severe weather
    case advisory
    /// An individual should prepare for potentially severe weather
    case watch
    /// An individual should take immediate action to protect themselves and others from potentially severe weather
    case warning
    
    init?(withName name:String) {
        switch name {
        case "advisory":
            self = .advisory
        case "watch":
            self = .watch
        case "warning":
            self = .warning
        default:
            return nil
        }
    }
    
    func name() -> String {
        switch self {
        case .advisory:
            return "Advisory"
        case .watch:
            return "Watch"
        case .warning:
            return "Warning"
        }
    }
    
    func description() -> String {
        switch self {
        case .advisory:
            return "Be aware of potentially severe weather."
        case .watch:
            return "Prepare for potentially severe weather."
        case .warning:
            return "Take immediate action to protect yourself and others from potentially severe weather."
        }
    }
}
