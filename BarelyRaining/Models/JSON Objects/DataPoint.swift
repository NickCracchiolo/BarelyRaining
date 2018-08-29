//
//  DataObject.swift
//  CMTWeather
//
//  Created by Nick Cracchiolo on 8/27/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import Foundation

/// A data point object contains various properties,
/// each representing the average (unless otherwise specified)
/// of a particular weather phenomenon occurring during a period of time:
/// an instant in the case of currently, a minute for minutely, an hour for hourly, and a day for daily.
struct DataPoint:Codable {
    /// The apparent (or “feels like”) temperature in degrees Fahrenheit. Only on Daily Weather.
    let apparentTemperature: Float?
    /// The daytime high apparent temperature. Only on Daily Weather.
    let apparentTemperatureHigh:Float?
    /// The UNIX time representing when the daytime high apparent temperature occurs. Only on Daily Weather.
    let apparentTemperatureHighTime:Date?
    /// The overnight low apparent temperature. Only on Daily Weather.
    let apparentTemperatureLow:Float?
    /// The UNIX time representing when the overnight low apparent temperature occurs. Only on Daily Weather.
    let apparentTemperatureLowTime:Date?
    /// The percentage of sky occluded by clouds, between 0 and 1, inclusive.
    let cloudCover:Float?
    /// The dew point in degrees Fahrenheit.
    let dewPoint:Float?
    /// The relative humidity, between 0 and 1, inclusive.
    let humidity:Float?
    /// A machine-readable text summary of this data point, suitable for selecting an icon for display.
    /// If defined, this property will have one of the following values: clear-day, clear-night, rain, snow, sleet, wind, fog, cloudy, partly-cloudy-day, or partly-cloudy-night.
    let icon:String?
    /// The fractional part of the lunation number during the given day: a value of 0 corresponds to a new moon, 0.25 to a first quarter moon, 0.5 to a full moon, and 0.75 to a last quarter moon.
    /// (The ranges in between these represent waxing crescent, waxing gibbous, waning gibbous, and waning crescent moons, respectively.)
    /// Only on DailyWeather.
    let moonPhase:Float?
    /// The approximate direction of the nearest storm in degrees, with true north at 0° and progressing clockwise.
    /// (If nearestStormDistance is zero, then this value will not be defined.).
    /// Only on Current Weather.
    let nearestStormBearing:Int?
    /// The approximate distance to the nearest storm in miles.
    /// (A storm distance of 0 doesn’t necessarily refer to a storm at the requested location, but rather a storm in the vicinity of that location.)
    /// Only on Current Weather
    let nearestStormDistance:Int?
    /// The columnar density of total atmospheric ozone at the given time in Dobson units.
    let ozone:Float?
    /// The amount of snowfall accumulation expected to occur, in inches. (If no snowfall is expected, this property will not be defined.)
    /// Only on Daily Weather and Hourly Weather
    let precipAccumulation:Float?
    /// The intensity (in inches of liquid water per hour) of precipitation occurring at the given time.
    /// This value is conditional on probability (that is, assuming any precipitation occurs at all) for minutely data points, and unconditional otherwise.
    let precipIntensity:Float?
    /// The standard deviation of the distribution of precipIntensity.
    /// (We only return this property when the full distribution, and not merely the expected mean, can be estimated with accuracy.)
    let precipIntensityError:Float?
    /// The maximum value of precipIntensity during a given day. Only on Daily Weather
    let precipIntensityMax:Float?
    /// The UNIX time of when precipIntensityMax occurs during a given day. Only on Daily Weather
    let precipIntensityMaxTime:Date?
    /// The probability of precipitation occurring, between 0 and 1, inclusive.
    let precipProbability:Float?
    /// The type of precipitation occurring at the given time.
    /// If defined, this property will have one of the following values: "rain", "snow", or "sleet" (which refers to each of freezing rain, ice pellets, and “wintery mix”).
    /// (If precipIntensity is zero, then this property will not be defined.
    /// Additionally, due to the lack of data in our sources, historical precipType information is usually estimated, rather than observed.)
    let precipType:String?
    /// The sea-level air pressure in millibars.
    let pressure:Float?
    /// A human-readable text summary of this data point.
    /// (This property has millions of possible values, so don’t use it for automated purposes: use the icon property, instead!)
    let summary:String?
    /// The UNIX time of when the sun will rise during a given day.
    /// Only on Daily Weather
    let sunriseTime:Date?
    /// The UNIX time of when the sun will set during a given day.
    /// Only on Daily Weather
    let sunsetTime:Date?
    /// The air temperature in degrees Fahrenheit.
    /// Not on Minute Weather
    let temperature:Float?
    /// The daytime high temperature. Only on Daily Weather.
    let temperatureHigh:Float?
    /// The UNIX time representing when the daytime high temperature occurs.
    /// Only on Daily Weather.
    let temperatureHighTime:Date?
    /// The overnight low temperature. Only on Daily Weather.
    let temperatureLow:Float?
    /// The UNIX time representing when the overnight low temperature occurs.
    /// Only on DailyWeather.
    let temperatureLowTime:Date?
    /// The UNIX time at which this data point begins.
    /// MinuteWeather data point are always aligned to the top of the minute,
    /// hourly data point objects to the top of the hour, and daily data point objects to midnight of the day,
    /// all according to the local time zone.
    let time:Date
    /// The UV Index
    let uvIndex:Int?
    /// The UNIX time of when the maximum uvIndex occurs during a given day.
    /// Only on Daily Weather.
    let uvIndexTime:Date?
    /// The average visibility in miles, capped at 10 miles.
    let visibility:Float?
    /// The direction that the wind is coming from in degrees, with true north at 0° and progressing clockwise.
    /// (If windSpeed is zero, then this value will not be defined.)
    let windBearing:Int?
    /// The wind gust speed in miles per hour.
    let windGust:Float?
    /// The time at which the maximum wind gust speed occurs during the day.
    /// Only on Daily Weather.
    let windGustTime:Date?
    /// The wind speed in miles per hour.
    let windSpeed:Float?
}
