//
//  UITableViewCellExtension.swift
//  CMTWeather
//
//  Created by Nick Cracchiolo on 8/27/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

extension UITableViewCell {
    class var identifier:String {
        return String(describing: self)
    }
}
