//
//  ViewController.swift
//  WeatherApp
//
//  Created by ahmed on 10/30/20.
//  Copyright © 2020 ahmed. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController:UIViewController,UITextFieldDelegate,CLLocationManagerDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherTableViewCell;
        cell.dateLabel.text="\(indexPath.row)"
        return cell
    }
    

    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var MaxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var searchBoxTextField: UITextField!
    let weatherApi=WeatherApi()
    let locationManager=CLLocationManager()
    let geoCoder = CLGeocoder()

    @IBOutlet weak var weatherForecastList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBoxTextField.delegate=self
        locationManager.delegate=self
        weatherForecastList.dataSource=self
        weatherForecastList.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        if let cityName = UserDefaultsManager.shared.cityName
 {
    searchBoxTextField.text=cityName
    weatherApi.getCurrentWeather(in: searchBoxTextField.text!,withCompletttion: self.bindUIData)

        }

    }

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
    
    @IBAction func onSearchBtnClick(_ sender: Any) {
        if searchBoxTextField.text?.trimmingCharacters(in:.whitespacesAndNewlines).count==0 {
                   searchBoxTextField.placeholder="Should enter city name"
               }
        else{
        searchBoxTextField.endEditing(true)
        }
        
    }
    
    @IBAction func onRequestLocation(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func bindUIData(weather:CurrentWeather?,error:Error?) -> Void {
        if(error == nil){
            UserDefaultsManager.shared.cityName=weather?.name
            DispatchQueue.main.async {
                if let currentWeather=weather,let main=weather?.main{
                self.currentTempLabel.text="\(main.feelsLike!)°C"
                self.minTempLabel.text="\(main.tempMin!)°C"
                self.MaxTempLabel.text="\(main.tempMax!)°C"
                  self.weatherIcon.image=UIImage(systemName: currentWeather.weather?.first?.conditionName ?? "")
                self.weatherDescriptionLabel.text=currentWeather.weather?.first?.weatherDescription!
                }
                
            }
            
        }
        else{
            DispatchQueue.main.async {

          self.showAlert(title: "Error!", msg: "Something has happend")
            }
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
   
    
    func showAlert(title:String,msg:String) -> Void {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
                   (alertAction: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
               }))
        self.present(alert, animated: false, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    /*    switch (status) {
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
        }*/
    }
    
   
    }
    

