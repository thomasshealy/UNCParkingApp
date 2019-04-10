//
//  TabBarController.swift
//  UNCParkingApplication
//
//  Created by Thomas Shealy on 2/5/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import UIKit
class TabBarController: UITabBarController {
    
    var scaleFactor = CGSize(width: 40, height: 40)

    override func viewDidLoad() {
        super.viewDidLoad()
        var map = UIImage(named: "48pxIcon_Location_White")
        map = map?.resizedImage(newSize: scaleFactor)
        
        var locations = UIImage(named: "48pxIcon_Car_White")
        locations = locations?.resizedImage(newSize: scaleFactor)
        
        var profile = UIImage(named: "48pxIcon_Profile_White")
        profile = profile?.resizedImage(newSize: scaleFactor)
        
        var info = UIImage(named: "48pxIcon_MoreInfo_White")
        info = info?.resizedImage(newSize: scaleFactor)
        
        
        
        
        self.tabBar.tintColor = UIColor.white
        
        let barColor = UIColor(red: 75/255, green: 156/255, blue: 211/255, alpha: 1)
        let size = CGSize(width: self.tabBar.frame.width, height: self.tabBar.frame.height)
        let background = UIImageView(image: getImageWithColor(color: barColor, size: size))
        background.frame = self.tabBar.bounds
        self.tabBar.backgroundImage = background.image
        self.tabBar.clipsToBounds = true
        
        //tabBar.barTintColor = barColor
        tabBar.isTranslucent = false
        //tabBar.unselectedItemTintColor = .blue
        
        var icons = [map, locations, profile, info]
        
        if let count = self.tabBar.items?.count{
            for i in 0...(count-1){
                self.tabBar.items?[i].image = icons[i]?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
            }
        }
        
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

extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
}
    
}
