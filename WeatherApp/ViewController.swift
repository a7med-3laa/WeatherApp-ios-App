//
//  ViewController.swift
//  WeatherApp
//
//  Created by ahmed on 10/30/20.
//  Copyright © 2020 ahmed. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController:UIViewController{
    
    
    @IBOutlet weak var weatherForeCaseHorizontal: UICollectionView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var MaxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var searchBoxTextField: UITextField!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var EnterTextLabel: UILabel!
    
    let weatherApi=WeatherApi()
    let locationManager=CLLocationManager()
    let geoCoder = CLGeocoder()
    var weatherForecasts:ForecastWeather?=nil

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBoxTextField.delegate=self
        weatherForeCaseHorizontal.dataSource=self
        weatherForeCaseHorizontal.register(UINib(nibName: "WeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        if let cityName = UserDefaultsManager.shared.cityName {
    searchBoxTextField.text=cityName
    weatherApi.getCurrentWeather(in: searchBoxTextField.text!,withCompletttion: self.bindUIData)

        }
        else{
            EnterTextLabel.isHidden=false
        }

    }

  
    @IBAction func onSearchBtnClick(_ sender: Any) {
        if searchBoxTextField.text?.trimmingCharacters(in:.whitespacesAndNewlines).count==0 {
                   searchBoxTextField.placeholder="Should enter city name"
               }
        else{
        searchBoxTextField.endEditing(true)
        }
        
    }
    
    @IBAction func onRequestLocation(_ sender: Any) {
        locationManager.delegate=self
        locationManager.requestWhenInUseAuthorization()
    }
    
 
    func bindUIData(weather:CurrentWeather?,forecastWeather:ForecastWeather?,error:Error?) -> Void {
     
         if(error == nil){
             UserDefaultsManager.shared.cityName=weather?.name
             DispatchQueue.main.async {
                 self.progressIndicator.isHidden=true

                 if let currentWeather=weather,let main=weather?.main{
                     self.currentTempLabel.text="\(main.feelsLike!.format(decimal:0)) °C"
                     self.minTempLabel.text="\(main.tempMin!.format(decimal:0))°C"
                     self.MaxTempLabel.text="\(main.tempMax!.format(decimal:0))°C"
                   self.weatherIcon.image=UIImage(systemName: currentWeather.weather?.first?.conditionName ?? "")
                 self.weatherDescriptionLabel.text=currentWeather.weather?.first?.weatherDescription!
                 self.weatherForecasts=forecastWeather
                     self.weatherForeCaseHorizontal.reloadData()
                 }
                 
             }
             
         }
         else{
             DispatchQueue.main.async {
                 self.progressIndicator.isHidden=true

           self.showAlert(title: "Error!", msg: "Something has happend")
             }
         }
         
     }
    
    
     
     func showAlert(title:String,msg:String) -> Void {
         let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
         alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
                    (alertAction: UIAlertAction!) in
             alert.dismiss(animated: true, completion: nil)
                }))
         self.present(alert, animated: false, completion: nil)
     }
     

}

//MARK:- Location Manager
extension ViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch (status) {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        case .authorizedAlways:
            locationManager.requestLocation()
        case .denied:
            showAlert(title: "Error", msg: "No Location accepted")

        case .restricted:
            showAlert(title: "Error", msg: "No Location accepted")
                
        case .notDetermined:
            return
        @unknown default:
        return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location=locations.last {
               locationManager.stopUpdatingLocation()
               
               let lat=location.coordinate.latitude
               let lng=location.coordinate.longitude
               geoCoder.reverseGeocodeLocation(location){placeMarks,err in
                   if (err == nil)
                   {
                       if let city = placeMarks?[0].locality {
                           self.searchBoxTextField.text=city
                       }
                   }
                   else{
                       self.showAlert(title: "Error", msg: err!.localizedDescription)
                   }
                   
               }
               self.weatherApi.getCurrentWeather(lat:lat,lng:lng,withCompletttion: self.bindUIData)
               
               
           }
       }
    
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
               showAlert(title: "error", msg: error.localizedDescription)
           
           
       }
}
//MARK:- CollectionDataSource
extension ViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let weatherForecast = weatherForecasts {
            return weatherForecast.list.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=weatherForeCaseHorizontal.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeatherCollectionViewCell;
               cell.dateLabel.text="\(indexPath.row)"
               if let weatherForecast=weatherForecasts{
                   let main=weatherForecast.list[indexPath.row]
                   let date=Date(timeIntervalSince1970: (TimeInterval(main.dt!)))
                   let simpleDateFormat=DateFormatter()
                   simpleDateFormat.dateFormat="EEEE";
                   cell.dateLabel.text=simpleDateFormat.string(from: date)
                cell.tempLabel.text="\(main.temp!.min.format(decimal:0))°C \\ \(main.temp!.max.format(decimal:0))°C"
               cell.weatherIcon.image=UIImage(systemName: main.weather?.first?.conditionName ?? "")
               
           }
                 return cell
               
    }
}

//MARK:- TextView Delegate
extension ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.endEditing(true)
          return true
      }
      func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
          if textField.text?.trimmingCharacters(in:.whitespacesAndNewlines).count==0 {
              textField.placeholder="Should enter city name"
              return false
          }
          return true;
      }
      func textFieldDidEndEditing(_ textField: UITextField) {
          weatherApi.getCurrentWeather(in: searchBoxTextField.text!,withCompletttion: self.bindUIData)

      }
      
}
    

