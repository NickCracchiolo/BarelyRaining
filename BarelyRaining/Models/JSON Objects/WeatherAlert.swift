//
//  WeatherAlert.swift
//  BarelyRaining
//
//  Created by Nick Cracchiolo on 8/27/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

/// The WeatherAlert object representing the severe weather warnings issued for the requested location by a governmental authority (please see our data sources page for a list of sources).
struct WeatherAlert:Codable {
    /// A detailed description of the alert.
    let description:String
    /// The UNIX time at which the alert will expire.
    let expires:Date
    /// An array of strings representing the names of the regions covered by this weather alert.
    let regions:[String]
    /// The severity of the weather alert.
    /// Will take one of the following values: "advisory" (an individual should be aware of potentially severe weather), "watch" (an individual should prepare for potentially severe weather), or "warning" (an individual should take immediate action to protect themselves and others from potentially severe weather).
    let severity:String
    /// The UNIX time at which the alert was issued.
    let time:Date
    /// A brief description of the alert.
    let title:String
    /// An HTTP(S) URI that one may refer to for detailed information about the alert.
    let uri:String
}
