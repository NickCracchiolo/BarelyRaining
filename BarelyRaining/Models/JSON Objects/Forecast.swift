//
//  Forecast.swift
//  BarelyRaining
//
//  Created by Nick Cracchiolo on 8/27/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

/// The main forecast object requested from the DarkSky API for the specified latitude and longitude.
struct Forecast:Codable {
    /// The requested latitude.
    let latitude:Float
    /// The requested longitude.
    let longitude:Float
    /// The IANA timezone name for the requested location. This is used for text summaries and for determining when hourly and daily DataBlock objects begin. E.G "America/New_York"
    let timezone:String
    /// A DataPoint object containing the current weather conditions at the requested location.
    let currently:DataPoint?
    /// A DataBlock object containing the weather conditions minute-by-minute for the next hour.
    let minutely:DataBlock?
    /// A DataBlock object containing the weather conditions hour-by-hour for the next two days.
    let hourly:DataBlock?
    /// A DataBlock object containing the weather conditions day-by-day for the next week.
    let daily:DataBlock?
    /// An array of WeatherAlert objects, which, if present, contains any severe weather alerts pertinent to the requested location.
    let alerts:[WeatherAlert]?
    /// A FlagObject containing miscellaneous metadata about the request.
    let flags:FlagObject?
}
