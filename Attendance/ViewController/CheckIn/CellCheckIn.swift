//
//  CellCheckIn.swift
//  Attendance
//
//  Created by MehulS on 02/10/17.
//  Copyright © 2017 MehulS. All rights reserved.
//

import UIKit

class CellCheckIn: UITableViewCell {
    
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var btnSearchLocation: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var txtSearchLocation: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var lblStartToEndLocation: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Current Location
        if btnCurrentLocation != nil {
            btnCurrentLocation.layer.cornerRadius = btnCurrentLocation.frame.size.width / 2
            btnCurrentLocation.layer.borderColor  = UIColor.black.cgColor
            btnCurrentLocation.layer.borderWidth  = 1.0
            btnCurrentLocation.layer.masksToBounds = true
        }
        
        //Search Location
        if btnSearchLocation != nil {
            btnSearchLocation.layer.cornerRadius = btnSearchLocation.frame.size.width / 2
            btnSearchLocation.layer.borderColor  = UIColor.black.cgColor
            btnSearchLocation.layer.borderWidth  = 1.0
            btnSearchLocation.layer.masksToBounds = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
