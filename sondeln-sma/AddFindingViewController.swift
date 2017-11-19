//
//  AddFindingViewController.swift
//  sondeln-sma
//
//  Created by Timo on 02.09.17.
//  Copyright © 2017 Timo. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class AddFindingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var condTextfield: UITextField!
    @IBOutlet weak var catTextfield: UITextField!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var postalLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    
    let catPicker = UIPickerView()
    let conductancePicker = UIPickerView()
    
    var locationManager = CLLocationManager()
    
    let cats = ["Undefinierbar", "Schrott", "Münze", "Waffe", "Kriegsfund", "Fliegerbombe", "Handgranate", "Deine Mudda", "Werkzeug", "Bauteile"]
    let conductance = ["1-5", "6-10", "11-15", "16-20", "21-25", "26-30", "31-35", "36-40", "41-45", "46-50", "51-55", "56-60", "61-65", "66-70", "71-75", "76-80", "81-85", "86-90", "91-95", "96-100"]
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    
    

    
    @IBAction func saveTapped(_ sender: Any) {
        // Parst das Datum und die Uhrzeit
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.string(from: dateTimePicker.date)
        print(strDate)
        dateFormatter.dateFormat = "HH:mm"
        let strTime = dateFormatter.string(from: dateTimePicker.date)
        print(strTime)
        
        let user = Auth.auth().currentUser
        
        if let title = titleTextfield.text, let cat = catTextfield.text, let conductance = condTextfield.text, let country = countryLabel.text, let city = cityLabel.text, let postal = postalLabel.text, let street = streetLabel.text, let user = user {
            
            let findingDictionary: [String: Any] = ["title":title, "category":cat, "conductance":conductance, "date":strDate, "time":strTime, "longitude": longitude, "latitude": latitude, "country": country, "city": city, "postal": postal, "street": street]
            
            Database.database().reference().child("findings").child(user.uid).childByAutoId().setValue(findingDictionary)
        }
        
        
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
    // MARK: Keyboard C0nfig
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddFindingViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        catPicker.delegate = self
        catTextfield.inputView = catPicker
        
        
        conductancePicker.delegate = self
        condTextfield.inputView = conductancePicker
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            latitude = coord.latitude
            longitude = coord.longitude
        }
        
        let userLocation: CLLocation = locations[0]
        
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if let placemark = placemarks?[0] {
                    if placemark.thoroughfare != nil {
                        if placemark.subThoroughfare != nil {
                            self.streetLabel.text = placemark.thoroughfare! + " " + placemark.subThoroughfare!
                        } else {
                            self.streetLabel.text = placemark.thoroughfare!
                        }
                    }
                    if placemark.postalCode != nil {
                        self.postalLabel.text = placemark.postalCode!
                    }
                    if placemark.country != nil {
                        self.countryLabel.text = placemark.country!
                    }
                    if placemark.locality != nil {
                        self.cityLabel.text = placemark.locality!
                    }
                }
            }
        }
    }
    
    // MARK: PickerView Settings
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == catPicker {
            return cats[row]
        } else if pickerView == conductancePicker {
            return conductance[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == catPicker {
            return cats.count
        } else if pickerView == conductancePicker {
            return conductance.count
        }
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == catPicker {
            catTextfield.text = cats[row]
        } else if pickerView == conductancePicker {
            condTextfield.text = conductance[row]
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
