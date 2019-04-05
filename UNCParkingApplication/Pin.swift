//
//  Pin.swift
//  UNCParkingApplication
//
//  Created by Thomas Shealy on 2/5/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import Foundation

class Pin{
    
    var latitude: Double
    var longitude: Double
    var username: String
    var description: String
    var title: String
    var link: String
    init(latitude: Double, longitude: Double, username: String, title: String, description: String, link: String
        ){
        self.latitude = latitude
        self.longitude = longitude
        self.username = username
        self.description = description
        self.title = title
        self.link = link
    }
    
    
    
    
}
