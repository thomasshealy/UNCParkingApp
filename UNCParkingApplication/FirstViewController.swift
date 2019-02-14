//
//  FirstViewController.swift
//  UNCParkingApplication
//
//  Created by Thomas Shealy on 2/4/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import UIKit
import MapKit

// This is a test
import Firebase


class FirstViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var pinList = [DictPin]()
    let locationMgr = CLLocationManager()
    var tempPin: Pin!
    var tempPin1: Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationMgr.delegate = self
        self.locationMgr.requestWhenInUseAuthorization()
        self.locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        self.locationMgr.requestLocation()
        mapView.delegate = self
        
        
        tempPin = Pin(lat: 35.903269, long: -79.041565, username: "Some Username", title: "UNC Hospital Lot", description: "Available after 5pm", link: "Some link")
        tempPin1 = Pin(lat: 35.912840, long: -79.047110, username: "Some Username", title: "Cobb Parking Deck", description: "Available with student parking pass", link: "Some link")
        
        markMap(tempPin)
        markMap(tempPin1)
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        if(view.annotation != nil){
            print("MKAnnotationView creation called")
            var annotation: MKAnnotation
            annotation = view.annotation!
            let lat = annotation.coordinate.latitude
            let long = annotation.coordinate.longitude
            let coordinates = CLLocationCoordinate2DMake(lat, long)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = annotation.title ?? "Selected Location"
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        print("MKAnnotation return called before nil")
        if annotation is MKUserLocation {
            return nil
        }
        
        print("MKAnnotation return called")
        let identifier = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        pinView?.pinTintColor = UIColor(red: 0.6, green: 0.729, blue: 0.867, alpha: 1.0)
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 60, height: 60)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "Car"), for: UIControl.State())
        pinView?.leftCalloutAccessoryView = button
        
        return pinView
    }
 
    
    func directionsfromPin(_ pin: DictPin){
        let lat = pin.pinLat
        let long = pin.pinLong
        let coordinates = CLLocationCoordinate2DMake(lat!, long!)
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
        
    }
    
    func markMap(_ pin: Pin){
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = pin.lat
        print(pin.lat)
        print(pin.long)
        annotation.coordinate.longitude = pin.long
        annotation.title = pin.title
        annotation.subtitle = pin.description
        mapView.addAnnotation(annotation)
        print("Gets called")
    }
    


}

extension FirstViewController{
    //tracks the users location and monitors for a change in location authorization (the user disables location services, etc.).
    func locationManager(_ manager:CLLocationManager, didChangeAuthorization status:
        CLAuthorizationStatus){
        if status == .authorizedWhenInUse{
            locationMgr.requestLocation()
        }
    }
    //Sets where the map initially zooms into and determines how far in the zoom is.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.first{
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            
            self.mapView.setRegion(region, animated: true)
            self.tempPin = Pin(lat: 35.903269, long: -79.041565, username: "Some Username", title: "UNC Hospital", description: "Availabile after 5pm", link: "Some link")
            
            self.markMap(tempPin)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("error:: (error)")
    }
}

