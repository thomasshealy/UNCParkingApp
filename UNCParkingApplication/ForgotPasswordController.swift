//
//  ForgotPasswordController.swift
//  UNCParkingApplication
//
//  Created by David Gallub on 3/16/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseAuth

class ForgotPasswordController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ForgotPasswordController.dismissKeyboard)))
        formatTextField(field: emailTextField)
    }
    
    @IBAction func resetPasswordButtonPressed(_ sender: Any) {
        if (emailTextField.text != nil) {
            Auth.auth().sendPasswordReset(withEmail:  emailTextField.text!) {error in
                if (error != nil) {
                    print("Error: " + (error?.localizedDescription)!)
                } else {
                    let alert = UIAlertController(title: "Forgot Password Email Sent", message: "Check your email in order to reset your password.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
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
    
}
