//
//  Defaults.swift
//  CMTWeather
//
//  Created by Nick Cracchiolo on 8/27/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

/// Struct used to keep UserDefault Keys.
struct Defaults {
    /// Used to specifiy the user's prefered default location.
    /// if equal to "Current Location" the use the user's current location, else check their previousSearches set of Locations
    static let defaultLocation = "defaultLocation"
    /// Used to specify user's prefered units (mpg vs kmph, meter vs inch, etc
    static let units = "units"
}
