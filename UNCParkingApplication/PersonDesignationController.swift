//
//  PersonDesignationController.swift
//  UNCParkingApplication
//
//  Created by Thomas Shealy on 2/21/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import UIKit

class PersonDesignationController: UIViewController {
    @IBOutlet weak var visitorButton: UIButton!
    @IBOutlet weak var studentButton: UIButton!
    @IBOutlet weak var univEmployeeButton: UIButton!
    @IBOutlet weak var healthButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImage(toSet: visitorButton)
        setImage(toSet: studentButton)
        setImage(toSet: univEmployeeButton)
        setImage(toSet: healthButton)
    }
    
    func setImage(toSet: UIButton){
        //toSet.setImage(UIImage(named: "Checkmarkempty"), for: .normal)
        //toSet.setImage(UIImage(named: "Checkmark"), for: .selected)
    }
    
    @IBAction func checkMarkTapped(_ sender: UIButton) {
        /*
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
        }) { (success) in
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
            
            
        }
 */
        self.presentRegisterController()
    }
    
    func presentRegisterController() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let registerController = storyboard.instantiateViewController(withIdentifier: "RegisterController") as! RegisterController
        present(registerController, animated: true, completion: nil)
    }
    

}
