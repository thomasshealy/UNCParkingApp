//
//  NotificationHandler.swift
//  UNCParkingApplication
//
//  Created by Thomas Shealy on 4/9/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import Foundation
import Firebase
import UserNotifications

class notificationHandler{
    
    init(){
        
    }
    
    func registerUserProperty(property: String){
        
        Analytics.setUserProperty(property, forName: "Parking_Passes")
        
    }
    

    
}
