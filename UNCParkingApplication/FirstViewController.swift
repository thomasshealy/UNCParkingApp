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


class FirstViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        
        filterMap(permit: permitPickerData[row])
        
        self.view.endEditing(true)
    }

    @IBOutlet weak var mapView: MKMapView!
    
    //anemail@gmail.com
    //pw: testtest
    var pinList = [DictPin]()
    let locationMgr = CLLocationManager()
    var tempPin: Pin!
    var tempPin1: Pin!
    var pinImage = UIImage(named: "72pxIcon_Map_Blue")
    
    var ref: DatabaseReference!
    var lotList =  [lotDict]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let permitPicker = UIPickerView()
        permitPicker.delegate = self
        
        getTime()
        
        filterField.inputView = permitPicker
        
        ref = Database.database().reference()
        
        print("Day of the Week: ", getDayOfWeek()!)
        
        getPermit()
        
        showAlert()
        
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
                self.permitPickerData.append("Weekday")
                self.permitPickerData.append("All")
                for x in tempData {
                    self.permitPickerData.append(x)
                }
                
                
            }
            
        })
        
        mapView.delegate = self
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.9063109, longitude: -79.0465444), span: span)
        
        self.mapView.setRegion(region, animated: true)

        self.locationMgr.delegate = self
        self.locationMgr.requestWhenInUseAuthorization()
        self.locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        self.locationMgr.requestLocation()
        
        pinImage = pinImage?.resizedImage(newSize: CGSize(width: 25, height: 25))
        tempPin = Pin(latitude: 35.903269, longitude: -79.041565, username: "Some Username", title: "UNC Hospital Lot", description: "Available after 5pm", link: "Some link")
        tempPin1 = Pin(latitude: 35.912840, longitude: -79.047110, username: "Some Username", title: "Cobb Parking Deck", description: "Available with student parking pass", link: "Some link")
        //Do some kind of iteration here where you loop through all of the coordinates and call translateCoords
        
        ref.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let value = snapshot.value as! NSDictionary
            let permits = (value["permits"] as! NSArray)
            self.filterMap(permit: (permits[0] as! String))
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
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
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if pinView == nil{
             pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView?.canShowCallout = true
            let smallSquare = CGSize(width: 60, height: 60)
            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
            button.setBackgroundImage(UIImage(named: "Car"), for: UIControl.State())
            pinView?.leftCalloutAccessoryView = button
             //pinView?.pinTintColor = UIColor(red: 0.6, green: 0.729, blue: 0.867, alpha: 1.0)
        }
        
        else{
            pinView?.annotation = annotation
        }
        
       
        pinView?.image = pinImage

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
    
    func showAlert(){
        if let alertChoice = UserDefaults.standard.object(forKey: "alert"){
            //do nothing
        }
        else{
            let alertText = "Weeknight Parking Hours are Monday - Thursday, 5 p.m. - 7:30 a.m. for more information please see the More Info page of this app. "
            let alertController = UIAlertController(title: "Weeknight Parking", message: alertText, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                alertController.dismiss(animated: true, completion: nil)
            }))
            alertController.addAction(UIAlertAction(title: "Don't Show Again", style: .default, handler: { (action: UIAlertAction!) in
                UserDefaults.standard.set("no", forKey: "alert")
                alertController.dismiss(animated: true, completion: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func weeknightPressed(_ sender: Any) {
        
        let annotations = self.mapView.annotations
        for an in annotations {
           self.mapView.removeAnnotation(an)
        }
        
        ref.child("weeknight").observe(DataEventType.value, with: { snapshot in
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
    
    func getDayOfWeek() -> Int?{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        return calendar.component(.weekday, from: date)
    }
    
    func getTime(){
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        print("hour: ", hour)
        print("minute: ", minutes)
    }
    
    func determineAccess(day: Int, hour: Int, minute: Int) -> String{
        //Tuesday-Thursday
        if day >= 3 || day <= 5{
           
        }
        //Sunday or Saturday
        else if day == 1 || day == 7{
            
        }
        //Monday
        else if day == 2{
            
        }
        //Friday
        else{
            
        }
        return "place holder"
    }
    
    
    
    func filterMap(permit: String) {
        
        let annotations = self.mapView.annotations
        for an in annotations {
            self.mapView.removeAnnotation(an)
        }
        
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
                    self.addLots()
                }
                
            })
            
        }
        else if permit == "Weekday"{
            ref.child("weekday").observe(DataEventType.value, with: { snapshot in
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
                    self.addLots()
                }
                
            })
        }
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
    func getPermit(){
        
        ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("permits").observeSingleEvent(of: .value, with: { (snapshot) in
            if let permits = snapshot.value as? [String] {
                print("Snap val: ", permits[0])
                self.registerUserProperty(property: permits)
            }
            else{
                print("Firebase read failed")
            }
        })
    }
}



