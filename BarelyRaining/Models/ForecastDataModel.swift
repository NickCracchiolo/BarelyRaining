//
//  ForecastDataModel.swift
//  CMTWeather
//
//  Created by Nick Cracchiolo on 8/27/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import CoreLocation

class ForecastDataModel:NSObject {
    weak var delegate:ForecastDataModelDelegate?
    
    // Manager to keep track of specific networking functions related to accessing the DarkSky API
    private let networkManager = NetworkManager()
    
    // Manager to access local storage using NSKeyedArchiver and NSKeyedUnarchiver
    private var storageManager = StorageManager(modelName: "PreviousLocations")
    
    // CLGeocoder used to get addresses from coordinates and coordinates from addresses.
    // See Apple documentation for more. (Use as little as possible per Apple's recommendations)
    private let geocoder = CLGeocoder()
    
    // Current user's set location
    var location:Location? {
        willSet {
            // Perform check to save last searched for location.
            // If the location is the user's current location (from GPS) it wont be saved.
            if let l = self.location, !l.current {
                // Save last checked location
                self.save(previousLocation: l)
            }
        }
        didSet {
            if let l = self.location {
                self.delegate?.didReceiveLocationUpdate(withLocation: l)
            }
        }
    }
    
    // Set so that multiple of the same locations don't show up and clutter the feed
    var previousLocations = Set<Location>()
    
    // Custom location manager. Make any changes (like accuracy, background use) to it here
    lazy var locationManager:CLLocationManager = {
        let loc = CLLocationManager()
        // Recommended by Apple for best battery life and accuracy for this purpose
        loc.desiredAccuracy = kCLLocationAccuracyKilometer
        loc.delegate = self
        return loc
    }()
    
    override init() {
        super.init()
        self.load()
    }
    
    /// Requests data from the DarkSky API with a set coordinates in the CLLocation object.
    /// Updates the delegate function after getting response and parsing JSON
    func requestData(forLocation loc:CLLocation) {
        networkManager.getForecast(forLatitude: loc.coordinate.latitude, lon: loc.coordinate.longitude) { [weak self] (forecast, error) in
            guard let s = self else {
                return
            }
            if let e = error {
                s.delegate?.didFail(withError: e)
            }
            if let f = forecast {
                s.delegate?.didReceiveUpdate(withForecastData: f)
            }
        }
    }
    /// Reloads the current location. Does not query CLGeocoder for a new name
    func reload() {
        if let l = self.location {
            self.requestData(forLocation: l.location)
        }
    }
    
    /// Sets the default location when app launches or when authorization fails
    func setDefaultLocation() {
        let d = UserDefaults.standard.string(forKey: Defaults.defaultLocation)
        if let loc = self.previousLocations.first(where: {$0.name == d}) {
            self.location = loc
        }
    }
    
    //// MARK: CLLocationManager functions
    func checkLocationAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            if self.location == nil {
                locationManager.startUpdatingLocation()
            }
        } else if status == .restricted || status == .denied {
            if UserDefaults.standard.string(forKey: Defaults.defaultLocation) == "Current Location" && self.location == nil {
                self.delegate?.authorizationDenied()
            }
        }
    }
    
    //// MARK: CLGeocoder related functions
    
    /// Uses CLGeocoder to return an address (String object) for a CLLocation (coordinates) object.
    /// Returns "Unknown" if an error occurs or no places are found by the geocoder
    func name(forLocation loc:CLLocation, completion: @escaping (String?) -> ()) {
        geocoder.reverseGeocodeLocation(loc) { [weak self] (placemarks, error) in
            if let e = error {
                print("Error with geocoder: \(e.localizedDescription)")
                completion("Unknown")
                return
            }
            guard let s = self else {
                completion(nil)
                return
            }
            if placemarks?.count ?? 0 > 0 {
                let p = placemarks![0]
                completion(s.name(fromPlacemark: p))
                return
            }
            completion("Unknown")
        }
    }
    
    /// Uses CLGeocoder to return a Location object for an address string.
    /// Returns an empty array if no locations can be found.
    func location(forName name:String, completion: @escaping ([Location]) -> ()) {
        geocoder.geocodeAddressString(name) { (placemarks, error) in
            if let e = error {
                print("Error: \(e.localizedDescription)")
                completion([])
                return
            }
            var locs:[Location] = []
            for p in placemarks ?? [] {
                // Only append locations with CLLocation objects
                if let l = p.location {
                    print(p)
                    locs.append(Location(name: "\(p.locality ?? ""), \(p.administrativeArea ?? "")", location: l))
                }
            }
            completion(locs)
        }
    }
    
    /// Adds a new Location to the set of previous locations and saves the new set to disk
    func save(previousLocation loc:Location) {
        // Check for the location's name instead of full equality because
        // the lat/lon for the same city/locaiton can differ slightly adding
        // multiple of the same locations
        if previousLocations.contains(where: { $0.name == loc.name }) { return }
        previousLocations.insert(loc)
        storageManager.save(objcect: previousLocations)
    }
    
    /// Loads in any previous locations saved to disk under the storageManager property's initialized model name
    func load() {
        if let prev = storageManager.load() as? Set<Location> {
            self.previousLocations = prev
        }
    }
    
    //// MARK: Private DataSource Helper Methods
    
    /// Nicely formats a locations name based off of a CLPlacemark
    /// Some strings can be nil depending on the user's search terms
    /// e.g. searching for New Mexico only returns an administrativeArea and country not a locality
    private func name(fromPlacemark p:CLPlacemark) -> String {
        var name:String = ""
        if let locality = p.locality {
            name += locality
            if let admin = p.administrativeArea {
                name += ", " + admin
                if let c = p.country {
                    name += ", " + c
                }
            } else {
                if let c = p.country {
                    name += ", " + c
                }
            }
        } else {
            if let admin = p.administrativeArea {
                name += admin
                if let c = p.country {
                    name += ", " + c
                }
            } else {
                if let c = p.country {
                    name += c
                }
            }
        }
        return name
    }
}
//// MARK: CLLocationManagerDelegate Functions
extension ForecastDataModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            print("Authorization Changed")
            locationManager.requestLocation()
            if let loc = locationManager.location {
                self.name(forLocation: loc) { (name) in
                    let l = Location(name: name ?? "Current Location", location: loc, current: true)
                    self.delegate?.didReceiveLocationUpdate(withLocation: l)
                }
            }
        } else if status == .restricted || status == .denied {
            if UserDefaults.standard.string(forKey: Defaults.defaultLocation) == "Current Location" {
                self.delegate?.authorizationDenied()
            } else {
                setDefaultLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location Updated: \(locations)")
        if let loc = locations.last {
            self.name(forLocation: loc) { (name) in
                let l = Location(name: name ?? "Current Location", location: loc, current: true)
                self.delegate?.didReceiveLocationUpdate(withLocation: l)
            }
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
