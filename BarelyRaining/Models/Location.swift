//
//  Location.swift
//  CMTWeather
//
//  Created by Nick Cracchiolo on 8/28/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import CoreLocation
import Foundation

/// Object used to save location names and coordinates (CCLocation).
class Location: NSObject, NSCoding {
    // Struct for keys for easy access and reuse
    private struct DecoderKeys {
        static let name = "name"
        static let location = "locations"
        static let current = "current"
    }
    
    var name:String
    var location:CLLocation
    var current:Bool
    
    init(name:String, location:CLLocation, current:Bool = false) {
        self.name = name
        self.location = location
        self.current = current
        super.init()
    }
    
    //// MARK: NSCoding Methods
    required init?(coder aDecoder: NSCoder) {
        if let n = aDecoder.decodeObject(forKey: DecoderKeys.name) as? String {
            self.name = n
        } else {
            self.name = ""
        }
        self.location = aDecoder.decodeObject(forKey: DecoderKeys.location) as! CLLocation
        self.current = aDecoder.decodeBool(forKey: DecoderKeys.current)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: DecoderKeys.name)
        aCoder.encode(self.location, forKey: DecoderKeys.location)
        aCoder.encode(self.current, forKey: DecoderKeys.current)
    }
}

