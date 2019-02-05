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
    var pinLat: Double!
    var pinLong: Double!
    var pinUsername: String!
    var pinDescription: String!
    var pinTitle: String!
    
    var pinKey: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>){
        
        self.pinKey = key
        
        if let lat = dictionary["lat"] as? Double{
            self.pinLat = lat
        }
        if let long = dictionary["long"] as? Double{
            self.pinLong = long
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
