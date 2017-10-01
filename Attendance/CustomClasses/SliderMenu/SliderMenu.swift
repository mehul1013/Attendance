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
    
    var delegate: SliderMenuDelegate!
    
    
    //MARK: - Set Attributes
    func setAttributes() -> Void {
        //Layer Properties
        btnProfile.layer.cornerRadius = btnProfile.frame.size.width / 2
        btnProfile.layer.masksToBounds = true
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
