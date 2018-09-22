# BarelyRaining
Basic iOS Weather App written in Swift using the Dark Sky API

## Features
* Uses CoreLocation to get the users current location
* Uses CLGeocoder to convert coordinates to addresses and addresses to coordinates
* Save previously searched locations using NSKeyedArchiver and NSKeyedUnarchiver
* Uses Codable to decode JSON from DarkSky API
* Built using MVC Architecture Pattern
* Uses Swift 4.2
* Shows current, hourly and daily weather conditions

### Notes
* No API key is current added. To use add your own DarkSky API key in NetworkManager.swift
* App is an MVP version of a weather app mainly for demonstrations and practice. Not currently on the App Store.
