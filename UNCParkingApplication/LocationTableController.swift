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

class LocationTableController: UITableViewController, CLLocationManagerDelegate, locationDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var filterField: UITextField!
    
    var permitPickerData: [String] = []
    var permitList = [PermitDict]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return permitPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return permitPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        filterList(permit: permitPickerData[row])
        self.view.endEditing(true)
        filterField.resignFirstResponder()
    }
    
    
    
    let locationMgr = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D!
    var tempPin: Pin!
    var tempPin1: Pin!
    var lotList = [lotDict]()
    var sortedList = [lotDict]()
    var tableList = [lotDict]()
    var distanceList = [lotDict]()
    var sortedDistanceList = [lotDict]()
    var ref: DatabaseReference!
    
    @IBOutlet var table: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let permitPicker = UIPickerView()
        permitPicker.delegate = self
        
        filterField.inputView = permitPicker
        
        ref = Database.database().reference()

        self.locationMgr.delegate = self
        self.locationMgr.requestWhenInUseAuthorization()
        self.locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        self.locationMgr.requestLocation()
        self.locationMgr.startUpdatingLocation()
        
        tempPin = Pin(latitude: 35.903269, longitude: -79.041565, username: "Some Username", title: "UNC Hospital Lot", description: "Available after 5pm", link: "Some link")
        tempPin1 = Pin(latitude: 35.912840, longitude: -79.047110, username: "Some Username", title: "Cobb Parking Deck", description: "Available with student parking pass", link: "Some link")
        
        table.delegate = self
        table.dataSource = self
        
        ref.child("permits").observe(DataEventType.value, with: {(snapshot) in
            self.permitList = []
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                print("enters if")
                for snap in snapshots {
                    if let permitDictionary = snap.value as? Dictionary<String, AnyObject> {
                        print("enters second if")
                        let key = snap.key
                        let permitData = PermitDict(key: key, dictionary: permitDictionary)
                        print("fire loop running")
                        self.permitList.append(permitData)
                        
                    }
                }
                var tempData: [String] = []
                for permit in self.permitList {
                    tempData.append(permit.permit_type)
                }
                tempData = [String](Set(tempData))
                tempData.sort()
                self.permitPickerData.append("Weeknight Parking")
                self.permitPickerData.append("Weekday Parking")
                self.permitPickerData.append("All")
                
                for x in tempData {
                    self.permitPickerData.append(x)
                }
                
                
               //self.sortLots()
              /*  for lot in self.lotList{
                    //let coord = CLLocationCoordinate2D(latitude: lot.latitude, longitude: lot.longitude)
                    self.calculateDistance(toMeasure: lot)
                    //self.getDriveTime(driveDestination: coord, lot: lot)
                }
                for lot in self.sortedDistanceList.prefix(through: 10){
                    let coord = CLLocationCoordinate2D(latitude: lot.latitude, longitude: lot.longitude)
                    self.getDriveTime(driveDestination: coord, lot: lot)
                }
 */
            }
            
        })
        
    ref.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            
          let value = snapshot.value as! NSDictionary
          let permits = (value["permits"] as! NSArray)
          self.filterList(permit: (permits[0] as! String))
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func calculateDistance(toMeasure: lotDict){
        
        let curLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let destinationLoc = CLLocation(latitude: toMeasure.latitude, longitude: toMeasure.longitude)
    
        let distanceTo = metersToMiles(toConvert: curLocation.distance(from: destinationLoc))
        toMeasure.travel_distance = distanceTo
        sortedDistanceList.append(toMeasure)
        sortDistance()
    }
    
    func metersToMiles(toConvert: Double) -> Double{
        var result = toConvert/1609.34
        result = result.roundTo(toPlaces: 2)
        return result
    }
    
    func addLabels(){
        tempPin = Pin(latitude: 35.903269, longitude: -79.041565, username: "Some Username", title: "UNC Hospital Lot", description: "Available after 5pm", link: "Some link")
        tempPin1 = Pin(latitude: 35.912840, longitude: -79.047110, username: "Some Username", title: "Cobb Parking Deck", description: "Available with student parking pass", link: "Some link")
        
        let loc0 = CLLocationCoordinate2D(latitude: tempPin.latitude, longitude: tempPin.longitude)
        let loc1 = CLLocationCoordinate2D(latitude: tempPin1.latitude, longitude: tempPin1.longitude)
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "lotCell", for: indexPath) as! LocationCell
        cell.delegate = self
        cell.nameLabel.text = sortedList[indexPath.row].lot_name
        cell.accessLabel.text = "Available with " + sortedList[indexPath.row].permit_type + " permit"
        let lotLatitude = sortedList[indexPath.row].latitude
        let lotLongitude = sortedList[indexPath.row].longitude
        let lotCoord = CLLocationCoordinate2D(latitude: lotLatitude ?? 0, longitude: lotLongitude ?? 0)
        cell.cellCoord = lotCoord
        cell.distanceLabel.text = translateTime(interval: sortedList[indexPath.row].travel_time)
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
    
    func getDriveTime(driveDestination: CLLocationCoordinate2D, lot: lotDict){
        
        let destinationMark = MKPlacemark(coordinate: driveDestination)
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
            let driveTime = self.translateTime(interval: primaryRoute.expectedTravelTime)
            lot.travel_time = primaryRoute.expectedTravelTime
            self.sortedList.append(lot)
            self.sortLots()
            //self.tableList = self.sortedList
            self.table.reloadData()
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
    
    func navPressed(cell: LocationCell){
        getDirections(cell.cellCoord, name: cell.nameLabel.text ?? "Selected Parking Lot")
    }
    
    func getDirections(_ coordinate: CLLocationCoordinate2D, name: String){
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        mapItem.name = name
        mapItem.openInMaps(launchOptions: launchOptions)
        
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
    
    func sortDistance(){
        for i in 0..<sortedDistanceList.count{
            for j in 1..<sortedDistanceList.count{
                if sortedDistanceList[j].travel_distance < sortedDistanceList[j-1].travel_distance{
                    let tmp = sortedDistanceList[j-1]
                    sortedDistanceList[j-1] = sortedDistanceList[j]
                    sortedDistanceList[j] = tmp
                }
            }
        }
    }
    
    func initiateCalculations(){
        for lot in lotList{
            //let coord = CLLocationCoordinate2D(latitude: lot.latitude, longitude: lot.longitude)
            calculateDistance(toMeasure: lot)
            //self.getDriveTime(driveDestination: coord, lot: lot)
        }
        if sortedDistanceList.count > 10{
        for lot in sortedDistanceList.prefix(through: 10){
            let coord = CLLocationCoordinate2D(latitude: lot.latitude, longitude: lot.longitude)
            getDriveTime(driveDestination: coord, lot: lot)
        }
        }
        else{
            for lot in sortedDistanceList{
                let coord = CLLocationCoordinate2D(latitude: lot.latitude, longitude: lot.longitude)
            getDriveTime(driveDestination: coord, lot: lot)
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
        if let latitude = locationMgr.location?.coordinate.latitude, let longitude = locationMgr.location?.coordinate.longitude{
            currentLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            addLabels()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("error:: (error)")
    }
    
    func filterList(permit: String) {
        
        if (permit == "All" || permit == "None") {
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
                    self.initiateCalculations()
                }
                
            })
            print("Done!")
            
        }
        else if permit == "Weekday Parking"{
            ref.child("weekday").observe(DataEventType.value, with: { snapshot in
                self.lotList = []
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    print("enters if")
                    for snap in snapshots {
                        if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                            print("enters second if")
                            print(postDictionary["permit_type"] as! String)
                            print(permit)
                            let key = snap.key
                            let lotData = lotDict(key: key, dictionary: postDictionary)
                            print("fire loop running")
                            self.lotList.append(lotData)
                        }
                    }
                    print("Loop ended")
                    
                    self.initiateCalculations()
                    
                }
                
            })
        }
        else if permit == "Weeknight Parking"{
            print("Enters weeknight if")
            ref.child("weeknight").observe(DataEventType.value, with: { snapshot in
                self.lotList = []
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    print("enters if")
                    for snap in snapshots {
                        if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                            print("enters second if")
                            print(postDictionary["permit_type"] as! String)
                            print(permit)
                                let key = snap.key
                                let lotData = lotDict(key: key, dictionary: postDictionary)
                                print("fire loop running")
                                self.lotList.append(lotData)
                        }
                    }
                    print("Loop ended")
                    
                    self.initiateCalculations()
                    
                }
                
            })
            
        }
        else {
            ref.child("lots").observe(DataEventType.value, with: { snapshot in
                self.lotList = []
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    print("enters if")
                    for snap in snapshots {
                        if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                            print("enters second if")
                            print(postDictionary["permit_type"] as! String)
                            print(permit)
                            if ((postDictionary["permit_type"] as! String) == permit) {
                                let key = snap.key
                                let lotData = lotDict(key: key, dictionary: postDictionary)
                                print("fire loop running")
                                self.lotList.append(lotData)
                            }
                        }
                    }
                    print("Loop ended")
                    
                    self.initiateCalculations()
 
                }
                
            })
        }
        sortedList.removeAll()
        sortedDistanceList.removeAll()
        tableView.reloadData()
    }
    
}

extension Double{
    func roundTo(toPlaces places: Int) -> Double{
        let divisor = pow(10.0, Double(places))
        return (self*divisor).rounded() / divisor
    }
}

