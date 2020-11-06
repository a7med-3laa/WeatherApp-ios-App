//
//  WeatherApis.swift
//  WeatherApp
//
//  Created by ahmed on 11/4/20.
//  Copyright © 2020 ahmed. All rights reserved.
//


import Foundation

class WeatherApi{
   
    
    func getCurrentWeather(in city:String,withCompletttion: @escaping (_ result:CurrentWeather?,_ err:Error?)->Void) {
        let url=Constant.CURRENT_WEATHER_URL+city
        getData(with: url, model: CurrentWeather.self, withCompletttion: withCompletttion)
    }
    
    func getCurrentWeather(lat:Double ,lng:Double,withCompletttion: @escaping (_ result:CurrentWeather?,_ err:Error?)->Void) {
        let url=String(format: Constant.CURRENT_WEATHER_URL_GEOLOCATION, lat,lng)
        getData(with: url, model: CurrentWeather.self, withCompletttion: withCompletttion)
    }
    
   
    
    private func getData<T: Decodable>(with url:String,model type:T.Type,  withCompletttion: @escaping (_ result:T?,_ err:Error?)->Void){
        let url = URL(string:url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        
        let urlSession=URLSession.init(configuration: .default).dataTask(with: url)
        { (data:Data? , urlResponse:URLResponse?, Err:Error?) in
            if Err != nil{
                print(Err!)
                    withCompletttion(nil,Err)

                return
            }
            if let jsonData = data{
                do {
                    let jsonDecoder=JSONDecoder()
                    let model = try jsonDecoder.decode(type, from: jsonData)
                        withCompletttion(model,nil)

                } catch {
                        withCompletttion(nil,error)

                    print(error)
                }
            }
            
        }
        
        urlSession.resume()
    }
    
}
