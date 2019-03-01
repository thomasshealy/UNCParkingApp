//
//  LoginController.swift
//  FirebaseCore
//
//  Created by Thomas Shealy on 2/14/19.
//

import UIKit

import Firebase
import FirebaseUI

class LoginController: UIViewController {
    
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard)))
        
        formatTextField(field: userField)
        formatTextField(field: passwordField)

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
    

    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
  
    @IBAction func loginButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: userField.text!, password: passwordField.text!) { (user, error) in
            
            if(error == nil){
                print("You have successfully logged in")
                if let email = self.userField.text{
                    UserDefaults.standard.set(email, forKey: "email")
                }
                self.presentHomePage()
            }
            else{
                let alertController = UIAlertController(title: "Error", message: "Invalid username and/or password", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                    alertController.dismiss(animated: true, completion: nil)
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func presentHomePage(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tab")
        self.present(vc!, animated: true, completion: nil)
    }
    
}
