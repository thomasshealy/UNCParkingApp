//
//  ProfileController.swift
//  UNCParkingApplication
//
//  Created by David Gallub on 3/19/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    
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
        let permits = permitField.text?.components(separatedBy: ". ")
        let push_notifications = (pushNotificationField.text == "Yes") ? true : false
        
        
    }
    
    
}
