//
//  Alert.swift
//  BarelyRaining
//
//  Created by Nick Cracchiolo on 8/28/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

struct Alert {
    static func noInternetConnection() -> UIAlertController {
        return Alert.createAlert(withTitle: "No Internet Connection", msg: "It looks like there is currently no internet connection. Please check your settings and connections then try again by hitting the refresh button.")
    }
    
    private static func createAlert(withTitle title:String, msg:String?) -> UIAlertController{
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        return alert
    }
}
