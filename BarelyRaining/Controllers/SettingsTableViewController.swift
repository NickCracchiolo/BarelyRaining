//
//  SettingsTableViewController.swift
//  CMTWeather
//
//  Created by Nick Cracchiolo on 8/27/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    // IBOutlets
    @IBOutlet weak var unitsField: UITextField!
    @IBOutlet weak var defaultField: UITextField!
    
    // Properties
    let units = ["us", "si"]
    var locations:[String] = ["Current Location"]
    var unitPicker = UIPickerView()
    var locationPicker = UIPickerView()
    var dataModel:ForecastDataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for l in self.dataModel.previousLocations {
            locations.append(l.name)
        }
        setupUnits()
        setupDefaultLocations()
    }
    
    /// Sets up the unitsField and unitsPicker for use
    private func setupUnits() {
        let unit = UserDefaults.standard.string(forKey: Defaults.units) ?? "us"
        unitPicker.dataSource = self
        unitPicker.delegate = self
        unitPicker.tag = 1
        let row = units.index(of: unit) ?? 0
        unitPicker.selectRow(row, inComponent: 0, animated: false)
        unitsField.text = unit
        unitsField.inputView = unitPicker
    }
    
    /// Sets up the defaultField and locationPicker for use
    private func setupDefaultLocations() {
        let loc = UserDefaults.standard.string(forKey: Defaults.defaultLocation) ?? "Current Location"
        locationPicker.dataSource = self
        locationPicker.delegate = self
        locationPicker.tag = 2
        let row = locations.index(of: loc) ?? 0
        locationPicker.selectRow(row, inComponent: 0, animated: false)
        defaultField.text = loc
        defaultField.inputView = locationPicker
    }
    
}

extension SettingsTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case unitPicker.tag:
            return 1
        case locationPicker.tag:
            return 1
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case unitPicker.tag:
            return units.count
        case locationPicker.tag:
            return locations.count
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case unitPicker.tag:
            return units[row]
        case locationPicker.tag:
            return locations[row]
        default:
            return nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case unitPicker.tag:
            let oldUnit = UserDefaults.standard.string(forKey: Defaults.units)
            // Only update if the units have changed, keeps API and CLGeocoder requests down
            if oldUnit != units[row] {
                // Update UserDefaults and the textField with the new value
                UserDefaults.standard.set(units[row], forKey: Defaults.units)
                self.unitsField.text = units[row]
                self.dataModel.reload()
            }
        case locationPicker.tag:
            let oldLoc = UserDefaults.standard.string(forKey: Defaults.defaultLocation)
            // Only update if the units have changed, keeps API and CLGeocoder requests down
            if oldLoc != locations[row] {
                // Update UserDefaults and the textField with the new value
                UserDefaults.standard.set(locations[row], forKey: Defaults.defaultLocation)
                self.defaultField.text = locations[row]
            }
        default:
            break
        }
        // Dismiss the pickerView/keyboard
        self.view.endEditing(true)
    }
}
