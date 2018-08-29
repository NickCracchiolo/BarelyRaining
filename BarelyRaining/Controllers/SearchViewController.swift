//
//  SearchViewController.swift
//  CMTWeather
//
//  Created by Nick Cracchiolo on 8/27/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var currentLocButton: UIBarButtonItem!
    
    let sectionHeaders = ["Search Results", "Previous Locations"]
    var dataModel:ForecastDataModel!
    var previousLocations:[Location] = []
    var searchResults:[Location] = []
    var selectedLocation:Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search for an Address, Zip, City, etc"
        self.previousLocations = Array(dataModel.previousLocations)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationAuth()
    }
    
    /// Function checks for location authorization.
    /// If authorization set to never, then disable current location bar button item
    private func checkLocationAuth() {
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            self.currentLocButton.isEnabled = false
        }
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Sets the WeatherViewController's location to the user's devices's location
    @IBAction func setCurrentLocation(_ sender: UIBarButtonItem) {
        dataModel.location = nil
        dataModel.locationManager.startUpdatingLocation()
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Searches for a location based on a String.
    /// Returns an array of results and displays them in the tableview
    func search(forLocation name:String) {
        dataModel.location(forName: name) { [weak self] (locations) in
            guard let s = self else { return }
            s.searchResults = []
            s.searchResults = locations
            
            DispatchQueue.main.async {
                let set = IndexSet(arrayLiteral: 0)
                s.tableView.reloadSections(set, with: .automatic)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return searchResults.count
        default:
            return previousLocations.count
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // Used to update WeatherViewController's main location when unwinding from a select
        switch indexPath.section {
        case 0:
            self.selectedLocation = searchResults[indexPath.row]
        default:
            self.selectedLocation = previousLocations[indexPath.row]
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier) as! LocationCell
        switch indexPath.section {
        case 0:
            cell.nameLabel.text = self.searchResults[indexPath.row].name
        default:
            cell.nameLabel.text = self.previousLocations[indexPath.row].name
        }
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let t = searchBar.text {
            search(forLocation: t)
        }
    }
}
