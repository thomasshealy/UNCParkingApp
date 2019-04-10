//
//  NavigationController.swift
//  UNCParkingApplication
//
//  Created by Thomas Shealy on 4/9/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = UIColor.white
        
        let barColor = UIColor(red: 75/255, green: 156/255, blue: 211/255, alpha: 1)
        let size = CGSize(width: self.navigationBar.frame.width, height: self.navigationBar.frame.height)
        let background = UIImageView(image: getImageWithColor(color: barColor, size: size))
        background.frame = self.navigationBar.bounds
        background.frame = CGRect(x: 0, y: 0, width: self.navigationBar.frame.width, height: self.navigationBar.frame.height)
        background.translatesAutoresizingMaskIntoConstraints = false
        self.navigationBar.setBackgroundImage(background.image, for: .default)
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
    

