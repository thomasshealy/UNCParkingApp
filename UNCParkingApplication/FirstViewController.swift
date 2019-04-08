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
    
    //dgallub1@live.unc.edu
    //pw: testtest
    
    var pinList = [DictPin]()
    let locationMgr = CLLocationManager()
    var tempPin: Pin!
    var tempPin1: Pin!
    
    var ref: DatabaseReference!
    var lotList =  [lotDict]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        self.locationMgr.delegate = self
        self.locationMgr.requestWhenInUseAuthorization()
        self.locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        self.locationMgr.requestLocation()
        
        mapView.delegate = self
        
        
        tempPin = Pin(latitude: 35.903269, longitude: -79.041565, username: "Some Username", title: "UNC Hospital Lot", description: "Available after 5pm", link: "Some link")
        tempPin1 = Pin(latitude: 35.912840, longitude: -79.047110, username: "Some Username", title: "Cobb Parking Deck", description: "Available with student parking pass", link: "Some link")
        //Do some kind of iteration here where you loop through all of the coordinates and call translateCoords
        
        ref.child("lots").observe(DataEventType.value, with: { snapshot in
            self.lotList = []
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                print("enters if")
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        print("enters second if")
                        let key = snap.key
                        let lotData = lotDict(key: key, dictionary: postDictionary)
                        print("fire loop running")
                        self.lotList.append(lotData)
                        
                    }
                }
                self.addLots()
            }
            
        })
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        if(view.annotation != nil){
            var annotation: MKAnnotation
            annotation = view.annotation!
            let latitude = annotation.coordinate.latitude
            let longitude = annotation.coordinate.longitude
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = annotation.title ?? "Selected Location"
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
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
    
    func markMap(_ pin: lotDict){
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = pin.latitude
        print(pin.latitude)
        print(pin.longitude)
        annotation.coordinate.longitude = pin.longitude
        annotation.title = pin.lot_name
        annotation.subtitle = "Available with " + pin.permit_type + " pass"
        mapView.addAnnotation(annotation)
        print("Gets called")
    }
    
    func addLots(){
        for lot in lotList{
            markMap(lot)
        }
    }
    
    func registerUserProperty(property: [String]){
        
        Analytics.setUserProperty(property[0], forName: "Parking_Passes")
        print("Register User Called: ", property[0])
        
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
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("error:: (error)")
    }
}

