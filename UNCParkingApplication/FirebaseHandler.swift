//
//  FirebaseHandler.swift
//  UNCParkingApplication
//
//  Created by Thomas Shealy on 3/21/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import Foundation
import Firebase

class FirebaseHandler{
    
    var path: String!
    var ref: DatabaseReference!
    var lotList = [lotDict]()
    
    init(path: String, ref: DatabaseReference){
        self.path = path
        self.ref = ref
    }
    
    func getLots() {
        ref.child("lots").observe(DataEventType.value, with: { snapshot in
            self.lotList = []
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                print("enters if")
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        print("enters second if")
                        let key = snap.key
                        let lotData = lotDict(key: key, dictionary: postDictionary)
                        print("fire loop running")
                        self.lotList.append(lotData)
                        
                    }
                }
            }
            
        })
    }
}


