//
//  PermitDict.swift
//  UNCParkingApplication
//
//  Created by Thomas Shealy on 3/20/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import Foundation

class PermitDict{
    
    var permit_type: String!
    
    var lotKey: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>){
        
        self.lotKey = key
        
        if let permit_type = dictionary["permit_type"] as? String{
            self.permit_type = permit_type
        }

    }
}

