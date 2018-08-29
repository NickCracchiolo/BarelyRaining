//
//  DailyWeather.swift
//  BarelyRaining
//
//  Created by Nick Cracchiolo on 8/27/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

struct DataBlock:Codable {
    /// A human-readable summary of this data block.
    let summary:String
    /// A machine-readable text summary of this data block. (May take on the same values as the iconproperty of DataPoints.)
    let icon:String?
    /// An array of DataPoint objects, ordered by time, which together describe the weather conditions at the requested location over time.
    let data:[DataPoint]
}
