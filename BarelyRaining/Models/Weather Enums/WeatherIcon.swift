//
//  WeatherIcon.swift
//  BarelyRaining
//
//  Created by Nick Cracchiolo on 8/27/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

/// Enum to parse the DarkSky "icon" string field into a usable UIImage
enum WeatherIcon {
    case clearDay
    case clearNight
    case rain
    case snow
    case sleet
    case wind
    case fog
    case cloudy
    case partyCloudyDay
    case partyCloudyNight
    case other
    
    init(withName name:String) {
        switch name {
        case "clear-day":
            self = .clearDay
        case "clear-night":
            self = .clearNight
        case "rain":
            self = .rain
        case "snow":
            self = .snow
        case "sleet":
            self = .sleet
        case "wind":
            self = .wind
        case "fog":
            self = .fog
        case "cloudy":
            self = .cloudy
        case "partly-cloudy-day":
            self = .partyCloudyDay
        case "partly-cloudy-night":
            self = .partyCloudyNight
        default:
            self = .other
        }
    }
    
    func image() -> UIImage? {
        switch self {
        case .clearDay:
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "sun.min")
            } else {
                return UIImage(named: "clear-day")
            }
        case .clearNight:
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "moon.stars")
            } else {
                return UIImage(named: "clear-night")
            }
        case .rain:
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "cloud.rain")
            } else {
                return UIImage(named: "rain")
            }
        case .snow:
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "snow")
            } else {
                return UIImage(named: "snow")
            }
        case .sleet:
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "wind.snow")
            } else {
                return UIImage(named: "sleet")
            }
        case .wind:
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "wind")
            } else {
                return UIImage(named: "wind")
            }
        case .fog:
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "cloud.fog")
            } else {
                return UIImage(named: "fog")
            }
        case .cloudy:
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "cloud")
            } else {
                return UIImage(named: "cloudy")
            }
        case .partyCloudyDay:
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "cloud.sun")
            } else {
                return UIImage(named: "partly-cloudy-day")
            }
        case .partyCloudyNight:
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "cloud.moon")
            } else {
                return UIImage(named: "partly-cloudy-night")
            }
        case .other:
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "globe")
            } else {
                return UIImage(named: "other")
            }
        }
    }
}
