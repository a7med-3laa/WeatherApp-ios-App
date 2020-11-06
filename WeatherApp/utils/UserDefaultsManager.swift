//
//  UserDefaultsManager.swift
//  WeatherApp
//
//  Created by ahmed on 11/6/20.
//  Copyright © 2020 ahmed. All rights reserved.
//

import Foundation

class UserDefaultsManager{
   
    static let shared = UserDefaultsManager()
    let defaults = UserDefaults.standard

    var cityName: String?{
        set(value){
            defaults.setValue(value, forKey: "city")
        }
        get{
            
            defaults.string(forKey: "city") ?? nil
        }
    }
    

    private init() { }


    
    
}
