//
//  RegisterController.swift
//  UNCParkingApplication
//
//  Created by Thomas Shealy on 2/14/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class RegisterController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmationField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
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
        passField.text = permitPickerData[row]
        self.view.endEditing(true)
    }
    
    var userID: String!
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let permitPicker = UIPickerView()
        permitPicker.delegate = self
        
        passField.inputView = permitPicker
        
        ref = Database.database().reference()
        
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
                self.permitPickerData.append("None")
                for x in tempData {
                    self.permitPickerData.append(x)
                }
                
                
            }
            
        })
        
        firstName.delegate = self
        lastName.delegate = self
        emailAddress.delegate = self
        //passField.delegate = self
        passwordField.delegate = self
        confirmationField.delegate = self
        
        
        formatTextField(field: firstName)
        formatTextField(field: lastName)
        formatTextField(field: emailAddress)
        formatTextField(field: passField)
        formatTextField(field: passwordField)
        formatTextField(field: confirmationField)
        
        //passwordField.text = String.fontAwesomeIcon(name: .github)
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterController.dismissKeyboard)))

       
    }
    
    func formatTextField(field: UITextField){
        let gray = UIColor.lightGray.cgColor
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = gray
        border.frame = CGRect(x: 0, y: field.frame.size.height - width, width: field.frame.size.width, height: field.frame.size.height)
        border.borderWidth = width
        field.layer.addSublayer(border)
        field.layer.masksToBounds = true
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        print("enters vaild email method")
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == emailAddress) {
            moveTextField(textField, moveDistance: -37, up: true)
        } else if (textField == passwordField) {
            moveTextField(textField, moveDistance: -75, up: true)
        } else if (textField == confirmationField) {
            moveTextField(textField, moveDistance: -150, up: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == emailAddress) {
            moveTextField(textField, moveDistance: -37, up: false)
        } else if (textField == passwordField) {
            moveTextField(textField, moveDistance: -75, up: false)
        } else if (textField == confirmationField) {
            moveTextField(textField, moveDistance: -150, up: false)
        }
    }
    
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Error", message: "Invalid field(s), please try gain", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        let alertController1 = UIAlertController(title: "Error", message: "Email Address already in use.", preferredStyle: .alert)
        alertController1.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            alertController1.dismiss(animated: true, completion: nil)
        }))
        
        let alertController2 = UIAlertController(title: "Success", message: "Your account was successfully created.", preferredStyle: .alert)
        alertController2.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: "toLogin", sender: nil)
        }))
        
        let email = emailAddress.text
        let password = passwordField.text
        let confirm = confirmationField.text
        
        if(firstName.hasText && lastName.hasText && emailAddress.hasText
            && passwordField.hasText && confirmationField.hasText && password == confirm
            && isValidEmail(testStr: email!)) && passField.hasText{
            
            Auth.auth().createUser(withEmail: email!, password: password!, completion: { (auth, error) in
                if error == nil {
                    print("successfully created user")
                    self.present(alertController2, animated: true, completion: nil)
                    let userDict : Dictionary<String, AnyObject> = [
                        "firstName": self.firstName.text as AnyObject,
                        "lastName": self.lastName.text as AnyObject,
                        "email": self.emailAddress.text as AnyObject,
                        "type": "None" as AnyObject,
                        "permits": [self.passField.text] as AnyObject,
                        "push_notifications": true as AnyObject
                    ]
                    let userID = Auth.auth().currentUser!.uid
                    self.ref.child("users").child(userID).setValue(userDict)
                    
                    /*
                     let storeCustomerIdCompletion: (String) -> Void = { customer_id in
                     // Put stripe customer id in database
                     let userDict : Dictionary<String, AnyObject> = [
                     "userLat": 0.00 as AnyObject,
                     "userLong": 0.00 as AnyObject,
                     "destinationLat": 0.00 as AnyObject,
                     "destinationLong": 0.00 as AnyObject,
                     "firstName": first as AnyObject,
                     "lastName": last as AnyObject,
                     "description": "Sample Description" as AnyObject,
                     "porterID": "place_holder" as AnyObject,
                     "stripeID": customer_id as AnyObject,
                     "email": email as AnyObject
                     ]
                     let userID = Auth.auth().currentUser!.uid
                     self.ref.child("AllUsers").child(userID).setValue(userDict)
                     print("ID saved as " + customer_id)
                     UserDefaults.standard.set(customer_id, forKey: "stripeID")
                     
                     }
                     */
                }else{
                    self.present(alertController1, animated: true, completion: nil)
                }
            })
            print("Successful Registration")
        }
        else{
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
}
