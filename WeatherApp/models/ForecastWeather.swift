//
//  ForecastWeather.swift
//  WeatherApp
//
//  Created by ahmed on 11/7/20.
//  Copyright © 2020 ahmed. All rights reserved.
//

import Foundation

// MARK: - Forecast
struct ForecastWeather: Codable {
    let city: City
    let cod: String
    let message: Double
    let cnt: Int
    let list: [CurrentWeather]
}
// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let country: String
    let population, timezone: Int
}
