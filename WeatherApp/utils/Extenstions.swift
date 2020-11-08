//
//  Extenstions.swift
//  WeatherApp
//
//  Created by ahmed on 11/8/20.
//  Copyright © 2020 ahmed. All rights reserved.
//

import Foundation

extension Double{
    
    func format(decimal:Int) -> String {
        return String(format: "%.0\(decimal)f", self)

  
    }
}
