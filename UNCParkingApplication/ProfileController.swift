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
    
    let permitPickerData = [String](arrayLiteral: "A", "BD", "CD", "CG", "DW", "FC", "FG", "JD", "K", "KSD", "L", "M", "MD", "N-8", "N1", "N10", "N11", "N2", "N3", "N4", "N5", "N7", "N8", "N9", "ND", "NG-1", "NG-3", "NG3", "PD", "PR", "R1", "R10", "R11", "R2", "R3", "R4", "R5", "R6", "R7", "R8", "R9", "S1", "S10", "S11", "S12", "S14", "S2", "S3", "S4", "S5", "S6", "S8", "S9", "SFH", "T", "W")
    
    let typePickerData = [String](arrayLiteral: "Visitor", "Student", "University Employee", "Health Care Employee")
    
    let pushNotificationPickerData = [String](arrayLiteral: "Yes", "No")
    
    // Tag to know which picker is used when
    enum PickerTag: Int {
        case PermitPicker
        case TypePicker
        case PushNotificationPicker
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
            case .PushNotificationPicker:
                return pushNotificationPickerData.count
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
            case .PushNotificationPicker:
                return pushNotificationPickerData[row]
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
            case .PushNotificationPicker:
                pushNotificationField.text = pushNotificationPickerData[row]
            }
            self.view.endEditing(true)
        } else {
            print("Error!")
        }
    }
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var permitField: UITextField!
    @IBOutlet weak var pushNotificationField: UITextField!
    
    /*
     let userID = Auth.auth().currentUser!.uid
     self.ref.child("users").child(userID).setValue(userDict)
    */
    
    
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up picker views
        let permitPicker = UIPickerView()
        permitPicker.tag = PickerTag.PermitPicker.rawValue
        permitPicker.delegate = self
        let typePicker = UIPickerView()
        typePicker.tag = PickerTag.TypePicker.rawValue
        typePicker.delegate = self
        let pushNotificationPicker = UIPickerView()
        pushNotificationPicker.tag = PickerTag.PushNotificationPicker.rawValue
        pushNotificationPicker.delegate = self
        
        permitField.inputView = permitPicker
        typeField.inputView = typePicker
        pushNotificationField.inputView = pushNotificationPicker
        
        
        
        
        
        
        
        ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as! NSDictionary
            self.nameField.text = (value["firstName"] as! String) + " " + (value["lastName"] as! String)
            self.typeField.text = (value["type"] as! String)
            let permits = (value["permits"] as! NSArray)
            self.permitField.text = (permits[0] as! String)
            let push_notifications = (value["push_notifications"] as! Bool)
            if (push_notifications) {
                self.pushNotificationField.text = "Yes"
            } else {
                self.pushNotificationField.text = "No"
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func saveChangesButtonPressed(_ sender: Any) {
        let name = nameField.text?.components(separatedBy: " ")
        let firstName = name![0]
        let lastName = name![1]
        let type = typeField.text
        let permits = [permitField.text]
        let push_notifications = (pushNotificationField.text == "Yes") ? true : false
        
        let updates = [
            "firstName" : firstName,
            "lastName" : lastName,
            "permits" : permits,
            "type" : type,
            "push_notifications" : push_notifications
            ] as [String : Any]
        
        ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).updateChildValues(updates)
        
        let alertController = UIAlertController(title: "Success", message: "Profile information updated.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
        print("Values updated!")
        
    }
    
    
}
