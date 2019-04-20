//
//  ProfileController.swift
//  UNCParkingApplication
//
//  Created by David Gallub on 3/19/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var permitPickerData: [String] = []
    
    var permitList = [PermitDict]()
    
    let typePickerData = [String](arrayLiteral: "Visitor", "Student", "University Employee", "Health Care Employee")
    
    let pushNotificationPickerData = [String](arrayLiteral: "Yes", "No")
    
    // Tag to know which picker is used when
    enum PickerTag: Int {
        case PermitPicker
        case TypePicker
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let tag = PickerTag(rawValue: pickerView.tag) {
            switch tag {
            case .PermitPicker:
                return permitPickerData.count
            case .TypePicker:
                return typePickerData.count
            }
        } else {
            print("Error!")
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let tag = PickerTag(rawValue: pickerView.tag) {
            switch tag {
            case .PermitPicker:
                return permitPickerData[row]
            case .TypePicker:
                return typePickerData[row]
            }
        } else {
            print("Error!")
            return "Error"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let tag = PickerTag(rawValue: pickerView.tag) {
            switch tag {
            case .PermitPicker:
                permitField.text = permitPickerData[row]
            case .TypePicker:
                typeField.text = typePickerData[row]
            }
            self.view.endEditing(true)
        } else {
            print("Error!")
        }
    }
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var permitField: UITextField!
    
    /*
     let userID = Auth.auth().currentUser!.uid
     self.ref.child("users").child(userID).setValue(userDict)
    */
    
    
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameField.isUserInteractionEnabled = false
        
        // Set up picker views
        let permitPicker = UIPickerView()
        permitPicker.tag = PickerTag.PermitPicker.rawValue
        permitPicker.delegate = self
        let typePicker = UIPickerView()
        typePicker.tag = PickerTag.TypePicker.rawValue
        typePicker.delegate = self
        
        permitField.inputView = permitPicker
        typeField.inputView = typePicker
        
        ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as! NSDictionary
            self.nameField.text = (value["firstName"] as! String) + " " + (value["lastName"] as! String)
            self.typeField.text = (value["type"] as! String)
            let permits = (value["permits"] as! NSArray)
            self.permitField.text = (permits[0] as! String)
            
        }) { (error) in
            print(error.localizedDescription)
        }
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
                for permit in self.permitList {
                    self.permitPickerData.append(permit.permit_type)
                }
                self.permitPickerData = [String](Set(self.permitPickerData))
                self.permitPickerData.sort()
                self.permitPickerData.insert("Visitor/No Permit", at: 0)
            }
    
        })
    }
    
    @IBAction func saveChangesButtonPressed(_ sender: Any) {
        let name = nameField.text?.components(separatedBy: " ")
        let firstName = name![0]
        let lastName = name![1]
        let type = typeField.text
        let permits = [permitField.text]
        let updates = [
            "firstName" : firstName,
            "lastName" : lastName,
            "permits" : permits,
            "type" : type
            ] as [String : Any]
        
        ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).updateChildValues(updates)
        Analytics.setUserProperty(permitField.text, forName: "Parking_Passes")
        
        let alertController = UIAlertController(title: "Success", message: "Profile information updated.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
        print("Values updated!")
        
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
            if Auth.auth().currentUser != nil {
                do {
                    try? Auth.auth().signOut()
                    
                    if Auth.auth().currentUser == nil {
                        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginController
                        self.present(loginVC, animated: true, completion: nil)
                    }
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func editInSettingsButtonPressed(_ sender: Any) {
        if let url = NSURL(string: UIApplication.openSettingsURLString) as URL? {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
