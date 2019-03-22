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
import Firebase

class LocationTableController: UITableViewController, CLLocationManagerDelegate {
    
    let locationMgr = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D!
    var tempPin: Pin!
    var tempPin1: Pin!
    var lotList = [lotDict]()
    var sortedList = [lotDict]()
    var ref: DatabaseReference!
    
    @IBOutlet var table: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        self.locationMgr.delegate = self
        self.locationMgr.requestWhenInUseAuthorization()
        self.locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        self.locationMgr.requestLocation()
        self.locationMgr.startUpdatingLocation()
        
        tempPin = Pin(lat: 35.903269, long: -79.041565, username: "Some Username", title: "UNC Hospital Lot", description: "Available after 5pm", link: "Some link")
        tempPin1 = Pin(lat: 35.912840, long: -79.047110, username: "Some Username", title: "Cobb Parking Deck", description: "Available with student parking pass", link: "Some link")
        
        table.delegate = self
        table.dataSource = self
        
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
                        self.table.reloadData()
                        
                    }
                }
               //self.sortLots()
            }
            
        })
        
    }
    
    func addLabels(){
        tempPin = Pin(lat: 35.903269, long: -79.041565, username: "Some Username", title: "UNC Hospital Lot", description: "Available after 5pm", link: "Some link")
        tempPin1 = Pin(lat: 35.912840, long: -79.047110, username: "Some Username", title: "Cobb Parking Deck", description: "Available with student parking pass", link: "Some link")
        
        let loc0 = CLLocationCoordinate2D(latitude: tempPin.lat, longitude: tempPin.long)
        let loc1 = CLLocationCoordinate2D(latitude: tempPin1.lat, longitude: tempPin1.long)
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "lotCell", for: indexPath) as! LocationCell
        print("row = ",indexPath.row)
        cell.nameLabel.text = sortedList[indexPath.row].lot_name
        cell.accessLabel.text = "Available with " + sortedList[indexPath.row].permit_type + " permit"
        let lotLat = sortedList[indexPath.row].lat
        let lotLong = sortedList[indexPath.row].long
        let lotCoord = CLLocationCoordinate2D(latitude: lotLat ?? 0, longitude: lotLong ?? 0)
        getDriveTime(walkDestination: lotCoord, label: cell.distanceLabel, lot: sortedList[indexPath.row])
        print("gets called")
        return cell
    }
    
    func getDriveTime(walkDestination: CLLocationCoordinate2D, label: UILabel, lot: lotDict){
        
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
            lot.travel_time = primaryRoute.expectedTravelTime
            self.sortedList.append(lot)
            self.sortLots()
            self.table.reloadData()
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
    
    func sortLots(){
        
        for i in 0..<sortedList.count{
            for j in 1..<sortedList.count{
                if sortedList[j].travel_time < sortedList[j-1].travel_time{
                    let tmp = sortedList[j-1]
                    sortedList[j-1] = sortedList[j]
                    sortedList[j] = tmp
                }
            }
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
