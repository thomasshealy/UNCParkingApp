//
//  LocationCell.swift
//  UNCParkingApplication
//
//  Created by Thomas Shealy on 3/21/19.
//  Copyright © 2019 UNC Transportation and Parking. All rights reserved.
//

import UIKit
import MapKit

protocol locationDelegate {
    func navPressed(cell: LocationCell)
}

class LocationCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var cellCoord: CLLocationCoordinate2D!
    var delegate: locationDelegate?

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func navPressed(_ sender: Any) {
        if let _ = delegate{
            delegate?.navPressed(cell: self)
        }
    }
    
}
