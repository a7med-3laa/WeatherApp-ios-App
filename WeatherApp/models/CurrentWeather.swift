//
//  Weather.swift
//  WeatherApp
//
//  Created by ahmed on 11/2/20.
//  Copyright © 2020 ahmed. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weather = try? newJSONDecoder().decode(Weather.self, from: jsonData)

import Foundation

// MARK: - Weather
struct CurrentWeather: Codable {
    let weather: [WeatherElement]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let dt: Int?
    let temp: Temp?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}


// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}


// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int
    let main, weatherDescription:String?
    let icon:String?
    
    var conditionName: String {
           switch id {
           case 200...232:
               return "cloud.bolt"
           case 300...321:
               return "cloud.drizzle"
           case 500...531:
               return "cloud.rain"
           case 600...622:
               return "cloud.snow"
           case 701...781:
               return "cloud.fog"
           case 800:
               return "sun.max"
           case 801...804:
               return "cloud.bolt"
           default:
               return "cloud"
           }
    }
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}


