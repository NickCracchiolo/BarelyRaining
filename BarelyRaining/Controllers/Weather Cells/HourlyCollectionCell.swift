//
//  HourlyCollectionCell.swift
//  BarelyRaining
//
//  Created by Nick Cracchiolo on 8/27/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class HourlyCollectionCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var roundedView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundedView.layer.cornerRadius = 5.0
        self.roundedView.layer.borderWidth = 2.0
        
        if #available(iOS 13.0, *) {
            self.roundedView.layer.borderColor = UIColor.label.cgColor
            self.roundedView.backgroundColor = .systemBackground
            self.backgroundColor = .systemBackground
            self.timeLabel.textColor = .label
            self.tempLabel.textColor = .label
            self.icon.tintColor = .label
        } else {
            self.roundedView.layer.borderColor = UIColor.black.cgColor
            self.icon.tintColor = .black
        }
    }
    
    lazy var formatter:DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h a"
        return f
    }()
    
    func setup(withData data:DataPoint) {
        if let i = data.icon {
            icon.image = WeatherIcon(withName: i).image()
        } else {
            icon.image = nil
        }
        timeLabel.text = formatter.string(from: data.time)
        if let temp = data.temperature {
            self.tempLabel.text = " " + String(format: "%.0f", roundf(temp)) + "˚"
        } else {
            self.tempLabel.text = "--˚"
        }
    }
}
