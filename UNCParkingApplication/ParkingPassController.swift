//
//  ParkingPassController.swift
//  UNCParkingApplication
//
//  Created by Thomas Shealy on 2/21/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import UIKit

class ParkingPassController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var picker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerData = ["None", "RR", "PX", "A", "N4", "Y"]
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return pickerData.count
    }
    
    var pickerData: [String] = [String]()
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
