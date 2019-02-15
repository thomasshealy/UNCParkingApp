//
//  RegisterController.swift
//  UNCParkingApplication
//
//  Created by Thomas Shealy on 2/14/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import UIKit

class RegisterController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmationField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
     var userID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstName.delegate = self
        lastName.delegate = self
        emailAddress.delegate = self
        passwordField.delegate = self
        confirmationField.delegate = self
        
        
        formatTextField(field: firstName)
        formatTextField(field: lastName)
        formatTextField(field: emailAddress)
        formatTextField(field: passwordField)
        formatTextField(field: confirmationField)
        
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
    

}
