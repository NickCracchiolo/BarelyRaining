//
//  FlagObject.swift
//  CMTWeather
//
//  Created by Nick Cracchiolo on 8/27/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

/// The FlagObject contains various metadata information related to the request.
struct FlagObject:Codable {
    /// Indicates the units which were used for the data in this request.
    let units:String
    /// This property contains an array of IDs for each data source utilized in servicing this request.
    let sources:[String]
    /// The distance to the nearest weather station that contributed data to this response. Note, however,
    /// that many other stations may have also been used; this value is primarily for debugging purposes.
    /// This property's value is in miles (if US units are selected) or kilometers (if SI units are selected).
    let nearestStation:Float
    /// The presence of this property indicates that the Dark Sky data source supports the given location,
    /// but a temporary error (such as a radar station being down for maintenance) has made the data unavailable.
    let darkskyUnavailable:String?
    
    private enum CodingKeys:String, CodingKey {
        case units
        case sources
        case nearestStation = "nearest-station"
        case darkskyUnavailable = "darksky-unavailable"
    }
}
