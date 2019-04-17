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
    
    @IBAction func buttonOnePressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://move.unc.edu/about/online-services/")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func buttonTwoPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://move.unc.edu/transit/")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func buttonThreePressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://move.unc.edu/parking/")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func buttonFourPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://move.unc.edu/cap/")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func buttonFivePressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://move.unc.edu/about/pricing/")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func buttonSixPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://move.unc.edu/events/")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func buttonSevenPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://itunes.apple.com/app/apple-store/id751972942?mt=8")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func buttonEightPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://parkmobile.app.link/SYLSYDYShR")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func weeknightPressed(_ sender: Any) {
         UIApplication.shared.open(URL(string: "https://move.unc.edu/weeknight-parking/")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func buttonNinePressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://move.unc.edu/")! as URL, options: [:], completionHandler: nil)
    }
    
}
