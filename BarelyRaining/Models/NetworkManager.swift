//
//  NetworkManager.swift
//  CMTWeather
//
//  Created by Nick Cracchiolo on 8/27/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

class NetworkManager {
    //Forecast Request: https://api.darksky.net/forecast/[key]/[lat],[lon]?[parameters]
    private let api = "https://api.darksky.net/forecast"
    private let key = "d64ebf1c220fdb7c03e2ee110d09d4a4"
    
    private lazy var decoder:JSONDecoder = {
        let decoder = JSONDecoder()
        // Used to decode the DarkSky UNIX time to Date objects
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    /// Function used to retrieve a forecast object for a specific latitude, longitude, and units.
    /// Specified units are saved into UserDefaults, the default value is "us"
    func getForecast(forLatitude lat:Double, lon:Double, completion: @escaping(Forecast?, Error?) -> ()) {
        let unit = UserDefaults.standard.string(forKey: Defaults.units) ?? "us"
        let url = URL(string: "\(api)/\(key)/\(lat),\(lon)?units=\(unit)")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let e = error {
                print("Error fetching data: \(e.localizedDescription)")
                completion(nil, e)
                return
            }
            guard let d = data else {
                print("Error: There was no data available!")
                completion(nil, nil)
                return
            }
            //print("JSON: \(String(describing: self.json(fromData: data)))")
            do {
                let forecast = try self.decoder.decode(Forecast.self, from: d)
                completion(forecast, nil)
            } catch let err {
                print("Error converting data \(err.localizedDescription)")
                completion(nil, err)
            }
        }
        task.resume()
    }
    
    /// Helper method to print out the raw JSON when necessary
    /// USED FOR DEBUGGING ONLY
    private func json(fromData data:Data?) -> [String:Any]? {
        if let d = data {
            do {
                let serial = try JSONSerialization.jsonObject(with: d, options: []) as? [String:Any]
                return serial
            } catch let e as NSError {
                print(e.localizedDescription)
            }
        }
        return nil
    }
}
