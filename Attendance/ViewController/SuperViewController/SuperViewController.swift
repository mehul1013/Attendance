//
//  SuperViewController.swift
//  Locus
//
//  Created by Mehul Solanki on 08/08/17.
//  Copyright © 2017 Mehul Solanki. All rights reserved.
//

import UIKit
import CoreLocation
import MessageUI

class SuperViewController: UIViewController, SliderMenuDelegate, MFMailComposeViewControllerDelegate {
    
    static var sliderMenu: SliderMenu!

    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set Right Bar Image
        self.showLeftBarIcon()
        
        //Init Slider Menu
        if SuperViewController.sliderMenu == nil && AppUtils.APPDELEGATE().isSliderMenuInitialise == false {
            //Reset Flag
            AppUtils.APPDELEGATE().isSliderMenuInitialise = true
            
            SuperViewController.sliderMenu = Bundle.main.loadNibNamed("SliderMenu", owner: self, options: nil)?.first as! SliderMenu
            SuperViewController.sliderMenu.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            AppUtils.APPDELEGATE().window?.addSubview(SuperViewController.sliderMenu)
            
            //Set Delegate
            SuperViewController.sliderMenu.delegate = self
            
            //Set Attributes
            SuperViewController.sliderMenu.setAttributes()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Show Left Bar Icon
    func showLeftBarIcon() -> Void {
        if self is Dashboard {
            let leftBar = UIBarButtonItem(image: UIImage(named: "Menu")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(btnMenuClicked))
            self.navigationItem.leftBarButtonItem = leftBar
        }else {
            let leftBar = UIBarButtonItem(image: UIImage(named: "Back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(btnBackClicked))
            self.navigationItem.leftBarButtonItem = leftBar
        }
    }
    
    
    //MARK: - Back Button
    func btnBackClicked() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Slider Menu
    func btnMenuClicked() -> Void {
        print("Menu Button Clicked")
        
        //Set Attributes
        SuperViewController.sliderMenu.setAttributes()
        
        UIView.animate(withDuration: 0.3, animations: {
            //Set Frame
            SuperViewController.sliderMenu.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }, completion: { (success) in
            //Completion Code
        })
    }
    
    //MARK: - Slider Menu Delegate
    func sliderMenuOption(_ index: Int) {
        if index == SliderMenuOption.PROFILE {
            //Profile
        }else if index == SliderMenuOption.MY_TEAM {
            //My Team
            self.navigateToMyTeam()
        }else if index == SliderMenuOption.MY_VISIT {
            //My Visit
            self.navigateToMtyVisits()
        }else if index == SliderMenuOption.CHECK_IN {
            //Check-In
            self.navigateToCheckIn()
        }else if index == SliderMenuOption.CONTACT_US {
            //Contact Us
            self.contactUs()
        }else if index == SliderMenuOption.LOGOUT {
            //Logout
            self.logout()
        }
    }
    
    
    //MARK: - My Team
    func navigateToMyTeam() -> Void {
        let myVisitVC = self.storyboard?.instantiateViewController(withIdentifier: "MyTeam") as! MyTeam
        self.navigationController?.pushViewController(myVisitVC, animated: true)
    }
    
    
    //MARK: - My Visits
    func navigateToMtyVisits() -> Void {
        let myVisitVC = self.storyboard?.instantiateViewController(withIdentifier: "MyVisits") as! MyVisits
        self.navigationController?.pushViewController(myVisitVC, animated: true)
    }
    
    //MARK: - Check-In
    func navigateToCheckIn() -> Void {
        let checkInVC = self.storyboard?.instantiateViewController(withIdentifier: "CheckIn") as! CheckIn
        self.navigationController?.pushViewController(checkInVC, animated: true)
    }
    
    
    //MARK: - Contact Us
    func contactUs() -> Void {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(["support@hrdatacube.com"])
            //composeVC.setSubject("StoryBook Feedback")
            //composeVC.setMessageBody("Hey Josh! Here's my feedback.", isHTML: false)
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }else {
            AppUtils.showAlertWithTitle(title: "", message: "Mail app is not configure in your device.", viewController: self)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(error?.localizedDescription ?? "Mail not succeed.")")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Logout
    func logout() -> Void {
        // create the alert
        let alert = UIAlertController(title: "Logout", message: "Are you sure, want to logout?", preferredStyle: .alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { action in
            
            //Clear User Default data
            UserDefaults.standard.set(nil, forKey: "LOGIN_ID")
            UserDefaults.standard.set(nil, forKey: "ROLE")
            UserDefaults.standard.set(nil, forKey: "NAME")
            UserDefaults.standard.set(nil, forKey: "department_name")
            UserDefaults.standard.set(nil, forKey: "designationname")
            UserDefaults.standard.set(nil, forKey: "companyid")
            UserDefaults.standard.set(nil, forKey: "BRANCH_ID")
            UserDefaults.standard.synchronize()

            
            // do something like...
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    

    //MARK: - Convert Data to Dictionary
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    //MARK: - Check Location Permission
    func isLocationPermitted() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                return true
            }
        }else {
            print("Location services are not enabled")
            return false
        }
    }

}
