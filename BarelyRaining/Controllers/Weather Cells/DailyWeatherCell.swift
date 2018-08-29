//
//  DailyWeatherCell.swift
//  BarelyRaining
//
//  Created by Nick Cracchiolo on 8/27/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class DailyWeatherCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    let formatter = DateFormatter()
    
    func setup(withData data:DataPoint) {
        if let i = data.icon {
            icon.image = WeatherIcon(withName: i).image()
        } else {
            icon.image = nil
        }
        let day = Calendar.current.component(.weekday, from: data.time)
        // Gets the Weekday name from the date. Minus 1 on index because day range is from 1-7, while array 0-6
        dayLabel.text = formatter.weekdaySymbols[day - 1]
        //print("Icon: \(data.icon) for day: \(formatter.weekdaySymbols[day - 1])")
        if let high = data.temperatureHigh {
            self.highLabel.text = String(format: "%.0f", high) + "˚"
        } else {
            self.highLabel.text = "--˚"
        }
        if let low = data.temperatureLow {
            self.lowLabel.text = String(format: "%.0f", low) + "˚"
        } else {
            self.lowLabel.text = "--˚"
        }
        self.summaryLabel.text = data.summary
    }
}
