//
//  ViewController.swift
//  mapApp
//
//  Created by Qiankang Zhou on 8/21/17.
//  Copyright © 2017 team_lk. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,  CLLocationManagerDelegate{
    
    @IBOutlet weak var myMap: MKMapView!
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var span = MKCoordinateSpanMake(0.005, 0.005)
    var initSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        myMap.userTrackingMode = .follow
        locationPermissin()
        initAltLocation()
        showCompass()
        showTrackingButton()
        addrToPlaceMark("1 S. Butler St, Madison, WI")
        addrToPlaceMark("218 E. Mifflin St, Madison, WI")
    }
    
    func addrToPlaceMark(_ addr: String){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(addr) {
            (placemarks, error) in
            guard let placemark = placemarks?.first
                else {
                print("GeoCoder fail")
                return
            }
            let lat = placemark.location?.coordinate.latitude
            let lon = placemark.location?.coordinate.longitude
            let annotation = MKPointAnnotation()
            annotation.title = "0"
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
            self.myMap.addAnnotation(annotation)
        }
    }
    
    
    
    func initAltLocation() {
        let altLocation = CLLocationCoordinate2D(latitude: 43.0731, longitude: -89.4012)
        let region = MKCoordinateRegion(center: altLocation, span: span)
        myMap.setRegion(region, animated: true)
        myMap.showsUserLocation = true
    }
    
    func showTrackingButton() {
        let button = MKUserTrackingButton(mapView: myMap)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10), button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)])
    }
    
    func showCompass() {
        let compass = MKCompassButton(mapView: myMap)
        compass.compassVisibility = .visible
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: compass)
        myMap.showsCompass = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let button = MKUserTrackingButton(mapView: myMap)
        self.view.addSubview(button)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationPermissin() {
        locationManager?.requestAlwaysAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currLocation = locations.first {
            currentLocation = currLocation
            if !initSet {
                let center = currentLocation?.coordinate
                let region = MKCoordinateRegion(center: center!, span: span)
                myMap.setRegion(region, animated: true)
                initSet = true
            }
        }
    }
}


