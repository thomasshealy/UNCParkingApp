//
//  DictPin.swift
//  UNCParkingApplication
//
//  Created by Thomas Shealy on 2/4/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import Foundation

//Stores pin data as dictionaries for easier Firebase reading/writing.
//Values can be retrieved easily through the instance variables.
class DictPin{
    var pinLatitude: Double!
    var pinLongitude: Double!
    var pinUsername: String!
    var pinDescription: String!
    var pinTitle: String!
    
    var pinKey: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>){
        
        self.pinKey = key
        
        if let latitude = dictionary["latitude"] as? Double{
            self.pinLatitude = latitude
        }
        if let longitude = dictionary["longitude"] as? Double{
            self.pinLongitude = longitude
        }
        if let username = dictionary["username"] as? String{
            self.pinUsername = username
        }
        if let description = dictionary["description"] as? String{
            self.pinDescription = description
        }
        if let title = dictionary["title"] as? String{
            self.pinTitle = title
        }
    }
}
