//
//  ForecastDataModelDelegate.swift
//  CMTWeather
//
//  Created by Nick Cracchiolo on 8/28/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

/// ForecastDataModel's Delegate. Sends messages to notify observer of location and forecast data changes
protocol ForecastDataModelDelegate: class {
    func didReceiveUpdate(withForecastData f:Forecast)
    func didReceiveLocationUpdate(withLocation loc:Location)
    func didFail(withError error:Error)
    func authorizationDenied()
}
