//
//  MoreInfoController.swift
//  UNCParkingApplication
//
//  Created by David Gallub on 2/6/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import UIKit

class MoreInfoController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func moreInfoButtonPressed(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: "https://move.unc.edu/parking/")! as URL, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func employeeButtonPressed(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: "https://move.unc.edu/parking/employee-parking/")! as URL, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func studentButtonPressed(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: "https://move.unc.edu/parking/student-parking/")! as URL, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func visitorButtonPressed(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: "https://move.unc.edu/parking/visitor-parking/")! as URL, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func meterButtonPressed(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: "https://move.unc.edu/parking/meters/")! as URL, options: [:], completionHandler: nil)
        
    }
    
    
    
    
    
}
