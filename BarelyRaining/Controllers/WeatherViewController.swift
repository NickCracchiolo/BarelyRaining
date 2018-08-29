//
//  ViewController.swift
//  CMTWeather
//
//  Created by Nick Cracchiolo on 8/27/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    // DataModel pulls data from DarkSky API
    private let dataModel:ForecastDataModel = ForecastDataModel()
    
    // Temp UITableView sources updated by dataModel
    var forecast:Forecast?
    var daily:[DataPoint] = []
    var hourly:[DataPoint] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        dataModel.delegate = self
        dataModel.setDefaultLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataModel.checkLocationAuthorization()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchSegue" {
            if let vc = segue.destination as? SearchViewController {
                vc.dataModel = self.dataModel
            }
        } else if segue.identifier == "settingsSegue" {
            if let vc = segue.destination as? SettingsTableViewController {
                vc.dataModel = self.dataModel
            }
        }
    }
    
    @IBAction func refreshWeather(_ sender: UIBarButtonItem) {
        print("Refreshing")
        dataModel.reload()
    }
    
    @IBAction func unwindToMainView(segue: UIStoryboardSegue) {
        if let vc = segue.source as? SearchViewController {
            if let l = vc.selectedLocation {
                self.dataModel.location = l
            } else {
                self.dataModel.location = nil
                dataModel.locationManager.startUpdatingLocation()
            }
        }
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 2 {
            // Added to comply with Dark Sky API requirements
            return "Powered by Dark Sky"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 128
        case 1:
            return 88
        default:
            return tableView.estimatedRowHeight
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return daily.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CurrentWeatherCell.identifier) as! CurrentWeatherCell
            cell.setup(withData: forecast?.currently)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyWeatherCell.identifier) as! HourlyWeatherCell
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.reloadData()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: DailyWeatherCell.identifier) as! DailyWeatherCell
            let d = daily[indexPath.row]
            cell.setup(withData: d)
            return cell
        }
    }
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourly.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionCell.identifier, for: indexPath) as! HourlyCollectionCell
        cell.setup(withData: hourly[indexPath.row])
        return cell
    }
}

extension WeatherViewController: ForecastDataModelDelegate {
    func didReceiveLocationUpdate(withLocation loc: Location) {
        print("Received Location Update")
        DispatchQueue.main.async {
            self.navigationItem.title = loc.name
        }
        dataModel.requestData(forLocation: loc.location)
    }
    
    func didReceiveUpdate(withForecastData f: Forecast) {
        print("Received Forecast Update")
        self.forecast = f
        self.daily = f.daily?.data ?? []
        let h = f.hourly?.data ?? []
        
        // Only get the next 24 hours of daily weather instead of the DarkSky default of 48
        // Can't always count on an array of size 48, so check added to make sure no index out of bounds error
        if h.count > 24 {
            self.hourly = Array(h[1...24])
        } else {
            self.hourly = h
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFail(withError error: Error) {
        print("DataModel failed with error: \(error.localizedDescription)")
        if error.localizedDescription == "The Internet connection appears to be offline." {
            // Alert for Internet Connection
            self.present(Alert.noInternetConnection(), animated: true, completion: nil)
        }
    }
    
    func authorizationDenied() {
        self.performSegue(withIdentifier: "searchSegue", sender: nil)
    }
}
