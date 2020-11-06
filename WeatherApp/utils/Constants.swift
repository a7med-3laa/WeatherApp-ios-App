//
//  Constants.swift
//  WeatherApp
//
//  Created by ahmed on 11/2/20.
//  Copyright © 2020 ahmed. All rights reserved.
//

import Foundation

struct Constant {
    static let CURRENT_WEATHER_URL="https://api.openweathermap.org/data/2.5/weather?appid=\(API_KEY)&units=metric&q="
    static let CURRENT_WEATHER_URL_GEOLOCATION="https://api.openweathermap.org/data/2.5/weather?appid=\(API_KEY)&units=metric&lat=%f&lon=%f"
    static let FORECAST_WEATHER_URL = "https://api.openweathermap.org/data/2.5/onecall?exclude=hourly,daily&appid=\(API_KEY)&lat=%f&lon=%f"
    static let API_KEY="962132b7359f26b94da4b22dbc362106"


}
