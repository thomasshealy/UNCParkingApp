//
//  LocationTableController.swift
//  UNCParkingApplication
//
//  Created by Thomas Shealy on 2/20/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationTableController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    let locationMgr = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D!
    var tempPin: Pin!
    var tempPin1: Pin!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationMgr.delegate = self
        self.locationMgr.requestWhenInUseAuthorization()
        self.locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        self.locationMgr.requestLocation()
        
    }
    
    func addLabels(){
        tempPin = Pin(lat: 35.903269, long: -79.041565, username: "Some Username", title: "UNC Hospital Lot", description: "Available after 5pm", link: "Some link")
        tempPin1 = Pin(lat: 35.912840, long: -79.047110, username: "Some Username", title: "Cobb Parking Deck", description: "Available with student parking pass", link: "Some link")
        
        let loc0 = CLLocationCoordinate2D(latitude: tempPin.lat, longitude: tempPin.long)
        let loc1 = CLLocationCoordinate2D(latitude: tempPin1.lat, longitude: tempPin1.long)
        
        getDriveTime(walkDestination: loc0, label: topLabel)
        getDriveTime(walkDestination: loc1, label: bottomLabel)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func getDriveTime(walkDestination: CLLocationCoordinate2D, label: UILabel){
        
        let destinationMark = MKPlacemark(coordinate: walkDestination)
        let directionDestination = MKMapItem(placemark: destinationMark)
        let sourceMark = MKPlacemark(coordinate: currentLocation)
        let directionSource = MKMapItem(placemark: sourceMark)
        let directionsRequest = MKDirections.Request()
        directionsRequest.transportType = .automobile
        directionsRequest.source = directionSource
        directionsRequest.destination = directionDestination
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate{(response, _) in
            guard let response = response else {return}
            let primaryRoute = response.routes[0] as MKRoute
            print("creates alert")
            let driveTime = self.translateTime(interval: primaryRoute.expectedTravelTime)
            label.text = driveTime + " Away"
        }
        
    }
    
    func translateTime(interval: TimeInterval) -> String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full
        if let formattedString = formatter.string(from: interval){
            return formattedString
        }
        else{
            return "Calculating Travel Time..."
        }
    }

}

extension LocationTableController{
    //tracks the users location and monitors for a change in location authorization (the user disables location services, etc.).
    func locationManager(_ manager:CLLocationManager, didChangeAuthorization status:
        CLAuthorizationStatus){
        if status == .authorizedWhenInUse{
            locationMgr.requestLocation()
        }
    }
    //Sets where the map initially zooms into and determines how far in the zoom is.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let lat = locationMgr.location?.coordinate.latitude, let long = locationMgr.location?.coordinate.longitude{
            currentLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
            addLabels()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("error:: (error)")
    }
}
