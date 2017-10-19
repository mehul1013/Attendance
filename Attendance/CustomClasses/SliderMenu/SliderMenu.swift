//
//  SliderMenu.swift
//  Attendance
//
//  Created by MehulS on 01/10/17.
//  Copyright © 2017 MehulS. All rights reserved.
//

import UIKit

//Delegate
protocol SliderMenuDelegate {
    func sliderMenuOption(_ index: Int)
}

class SliderMenu: UIView {

    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    
    @IBOutlet weak var btnMyTeam: UIButton!
    @IBOutlet weak var constraintHeight_MyTeam: NSLayoutConstraint!
    
    var delegate: SliderMenuDelegate!
    
    
    //MARK: - Set Attributes
    func setAttributes() -> Void {
        //Layer Properties
        btnProfile.layer.cornerRadius = btnProfile.frame.size.width / 2
        btnProfile.layer.masksToBounds = true
        
        //Assign Name
        lblName.text = AppUtils.APPDELEGATE().Name
        lblDesignation.text = AppUtils.APPDELEGATE().DesignationName
        
        //Name Letters
        let arrayName = AppUtils.APPDELEGATE().Name.components(separatedBy: " ")
        var firstName = ""
        var lastName = ""
        if arrayName.count > 0 {
            firstName = arrayName.first!
        }
        if arrayName.count > 1 {
            lastName = arrayName.last!
        }
        //firstName = Array(firstName)[0]
        if firstName.characters.count > 0 {
            let firstChar = firstName[firstName.index(firstName.startIndex, offsetBy: 0)]
            let lastChar  = lastName[lastName.index(lastName.startIndex, offsetBy: 0)]
            
            btnProfile.setTitle("\(firstChar)\(lastChar)", for: .normal)
        }else {
            btnProfile.setTitle("", for: .normal)
        }
        
        
        
        //Check if MY TEAM need to show or not
        if AppUtils.APPDELEGATE().Role == "5" {
            //Do Nothing
            btnMyTeam.isHidden = false
            constraintHeight_MyTeam.constant = 35
            self.layoutIfNeeded()
        }else {
            //Hide MY TEAM option
            btnMyTeam.isHidden = true
            constraintHeight_MyTeam.constant = 0
            self.layoutIfNeeded()
        }
    }
    
    //MARK: - Close Menu
    @IBAction func btnCloseMenuClicked(_ sender: Any) {
        if self.frame.origin.x >= 0 {
            UIView.animate(withDuration: 0.3, animations: {
                //Set Frame
                self.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }, completion: { (success) in
                //Completion Code
            })
        }
    }
    
    
    //MARK: - Menu Option
    @IBAction func btnMenuOptionClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            //Set Frame
            self.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }, completion: { (success) in
            //Completion Code
            self.delegate.sliderMenuOption(sender.tag)
        })
    }
    
    
}
