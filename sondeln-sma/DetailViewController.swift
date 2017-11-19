//
//  DetailViewController.swift
//  sondeln-sma
//
//  Created by Timo on 07.09.17.
//  Copyright © 2017 Timo. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class DetailViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var catLabel: UILabel!
    @IBOutlet weak var conductanceLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var postalLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var finding : DataSnapshot?

    @IBAction func trashTapped(_ sender: Any) {
        if let key = finding?.key {
            if let userId = Auth.auth().currentUser?.uid {
                Database.database().reference().child("findings").child(userId).child(key).removeValue()
                navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let findingDictionary = finding?.value as? NSDictionary {
            
            // Location
            if let longitude = findingDictionary["longitude"] as? Double {
                if let latitude = findingDictionary["latitude"] as? Double {
                    
                    let locationLongitude: CLLocationDegrees = longitude
                    let locationLatitude: CLLocationDegrees = latitude
                    let latDelta: CLLocationDegrees = 0.01
                    let lonDelta: CLLocationDegrees = 0.01
                    
                    let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
                    let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: locationLatitude, longitude: locationLongitude)
                    
                    let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
                    mapView.setRegion(region, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    mapView.addAnnotation(annotation)
                }
            }
            
            // Restliche Detail Infos aus Dictionary sucken
            if let title = findingDictionary["title"] as? String {
                titleLabel.text = title
            }
            if let date = findingDictionary["date"] as? String {
                let formattetDate = date.replacingOccurrences(of: "-", with: ".")
                dateLabel.text = formattetDate
            }
            if let time = findingDictionary["time"] as? String {
                timeLabel.text = time
            }
            if let cat = findingDictionary["category"] as? String {
                catLabel.text = cat
            }
            if let conductance = findingDictionary["conductance"] as? String {
                conductanceLabel.text = conductance
            }
            if let street = findingDictionary["street"] as? String {
                streetLabel.text = street
            }
            if let postal = findingDictionary["postal"] as? String {
                postalLabel.text = postal
            }
            if let city = findingDictionary["city"] as? String {
                cityLabel.text = city
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
