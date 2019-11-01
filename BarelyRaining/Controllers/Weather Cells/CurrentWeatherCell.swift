//
//  CurrentWeatherCell.swift
//  BarelyRaining
//
//  Created by Nick Cracchiolo on 8/27/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class CurrentWeatherCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    //@IBOutlet weak var locationLabel: UILabel!
    //@IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var uvLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    func setup(withData data:DataPoint?) {
        guard let d = data else {
            self.icon.image = nil
            self.tempLabel.text = "--˚"
            self.feelsLikeLabel.text = nil
            //self.summaryLabel.text = ""
            self.humidityLabel.text = "Humidity: --%"
            self.precipitationLabel.text = "Precipitation: --%"
            self.uvLabel.text = "UV Index: --"
            self.windLabel.text = "Wind: -- mph"
            return
        }
        
        if let i = d.icon {
            self.icon.image = WeatherIcon(withName: i).image()
            if #available(iOS 13.0, *) {
                self.icon.tintColor = .label
            } else {
                self.icon.tintColor = .black
            }
        } else {
            self.icon.image = nil
        }
        if let t = d.temperature {
            self.tempLabel.text = String(format: "%.0f", roundf(t)) + "˚"
        } else {
            self.tempLabel.text = "--˚"
        }
        if let feelsLike = d.apparentTemperature {
            self.feelsLikeLabel.text = "Feels like " + String(format: "%.0f", roundf(feelsLike)) + "˚"
        } else {
            self.feelsLikeLabel.text = nil
        }
//        if let summary = d.summary {
//            self.summaryLabel.text = summary
//        } else {
//            self.summaryLabel.text = ""
//        }
        
        if let humid = d.humidity {
            self.humidityLabel.text = "Humidity: " + String(format: "%.0f", roundf(humid * 100)) + "%"
        } else {
            self.humidityLabel.text = "Humidity: --%"
        }
        
        if let p = d.precipProbability {
            self.precipitationLabel.text = "Precipitation: " + String(format: "%.0f", roundf(p * 100)) + "%"
        } else {
            self.precipitationLabel.text = "Precipitation: --%"
        }
        
        if let uv = d.uvIndex {
            self.uvLabel.text = "UV Index: \(uv)"
        } else {
            self.uvLabel.text = "UV Index: --"
        }
        
        if let windSpeed = d.windSpeed {
            let unit = UserDefaults.standard.string(forKey: Defaults.units) ?? "us"
            self.windLabel.text = "Wind: " + String(format: "%.0f", roundf(windSpeed)) + (unit == "us" ? " mph" : " m/s")
        }
    }
}
