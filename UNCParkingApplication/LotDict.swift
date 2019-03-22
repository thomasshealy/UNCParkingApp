//
//  LotDict.swift
//  UNCParkingApplication
//
//  Created by Thomas Shealy on 3/20/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import Foundation

class lotDict{
    var lat: Double!
    var long: Double!
    var object_id: Int!
    var lot_name: String!
    var lot_num: String!
    var permit_type: String!
    var time: String!
    var travel_time: TimeInterval!
    
    var lotKey: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>){
        
        self.lotKey = key
        self.travel_time = 999999.9
        
        if let lat = dictionary["lat"] as? Double{
            self.lat = lat
        }
        if let long = dictionary["long"] as? Double{
            self.long = long
        }
        if let object_id = dictionary["object_id"] as? Int{
            self.object_id = object_id
        }
        if let lot_name = dictionary["lot_name"] as? String{
            self.lot_name = lot_name
        }
        if let lot_num = dictionary["lot_num"] as? String{
            self.lot_num = lot_num
        }
        if let permit_type = dictionary["permit_type"] as?
            String{
            self.permit_type = permit_type
        }
        if let time = dictionary["time"] as?
            String{
            self.time = time
        }
    }
}
