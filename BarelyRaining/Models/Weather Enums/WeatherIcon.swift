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
            return UIImage(named: "clear-day")
        case .clearNight:
            return UIImage(named: "clear-night")
        case .rain:
            return UIImage(named: "rain")
        case .snow:
            return UIImage(named: "snow")
        case .sleet:
            return UIImage(named: "sleet")
        case .wind:
            return UIImage(named: "wind")
        case .fog:
            return UIImage(named: "fog")
        case .cloudy:
            return UIImage(named: "cloudy")
        case .partyCloudyDay:
            return UIImage(named: "partly-cloudy-day")
        case .partyCloudyNight:
            return UIImage(named: "partly-cloudy-night")
        case .other:
            return UIImage(named: "other")
        }
    }
}
