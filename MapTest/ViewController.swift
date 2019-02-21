//
//  ViewController.swift
//  MapTest
//
//  Created by Harshit Aggarwal on 2/20/19.
//  Copyright © 2019 Harshit Aggarwal. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var input: UITextField!
    lazy var geocoder = CLGeocoder()
    
    let regionRadius: CLLocationDistance = 350.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let modHQ = CLLocation(latitude: 39.950220, longitude: -75.163700)
        let annotate = MKPointAnnotation()
        annotate.coordinate = modHQ.coordinate
        
        let region = MKCoordinateRegion(center: modHQ.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.mapView.addAnnotation(annotate)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func UpdateMap() {

        guard let address = input.text else { return }
        print(address)
        geocoder.geocodeAddressString(address) {
            [weak self] (placemarks, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            guard let placemark = placemarks?.first else {
                print("No placemark")
                return }
            guard let location = placemark.location else {
                print("No location in placemark")
                return }
            
            // Set Region Radius
            let regionRadius: CLLocationDistance = 350.0
            
            // Set Annotations
            let annotate = MKPointAnnotation()
            annotate.coordinate = location.coordinate
            
            let lat = location.coordinate.latitude.rounded()
            let lon = location.coordinate.longitude.rounded()
            print("\(lat) , \(lon)")
            
            self?.getWeather(lat: lat, lon: lon)
           
            
            // Plot
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            self?.mapView.addAnnotation(annotate)
            self?.mapView.setRegion(region, animated: true)
            }
       }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    


    func getWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        
        let apitoken = " "
        
        let session = URLSession.shared
        let weather = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=imperial&APPID=\(apitoken)"
        
        guard let weatherURL = URL(string: weather) else { return }
        
        let task = session.dataTask(with: weatherURL) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let data = data {
                if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                    if let mainDictionary = jsonObj!.value(forKey: "main") as? NSDictionary {
                        if let temperature = mainDictionary.value(forKey: "temp") {
                            DispatchQueue.main.async {
                                
                                let truncTemp = Int(Float("\(temperature)") ?? 70.0)
                                let max = mainDictionary.value(forKey: "temp_max")
                                let min = mainDictionary.value(forKey: "temp_min")
                                
                                let truncMax = Int(Float("\(max!)") ?? 70.0)
                                let truncMin = Int(Float("\(min!)") ?? 70.0)
                                
                                let mainDictionary2 = jsonObj?.value(forKey: "weather") as! NSArray
                                let mainDictionary3 = mainDictionary2[0] as? NSDictionary
                                let mainDictionary4 = mainDictionary3?.value(forKey: "main")
                                                            }
                }
            }
                    }
            } else {
                print("Data Error")
            }
    }
        task.resume()
}

}

                        


