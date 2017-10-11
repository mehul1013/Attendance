//
//  Login.swift
//  Attendance
//
//  Created by MehulS on 10/09/17.
//  Copyright © 2017 MehulS. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class Login: SuperViewController {

    @IBOutlet weak var constraintCenterY_Logo: NSLayoutConstraint!
    
    @IBOutlet weak var viewCompany: UIView!
    @IBOutlet weak var txtCompany: UITextField!
    
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var txtUserID: UITextField!
    
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    let arrayCompany = ["Gcell", "Mace"]
    var indexCompanySelected = 0
    
    
    //View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Setup UI
        self.setupUI()
        
        //Show Animation
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(startAnimation), userInfo: nil, repeats: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //No need to show Navigation Bar
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Set Up UI
    func setupUI() -> Void {
        //UIView Background Color and Layer Properties
        viewCompany.backgroundColor     = UIColor.clear
        viewCompany.layer.borderColor   = UIColor.white.cgColor
        viewCompany.layer.borderWidth   = 1.0
        viewCompany.alpha               = 0.0
        
        viewUser.backgroundColor        = UIColor.clear
        viewUser.layer.borderColor      = UIColor.white.cgColor
        viewUser.layer.borderWidth      = 1.0
        viewUser.alpha                  = 0.0
        
        viewPassword.backgroundColor    = UIColor.clear
        viewPassword.layer.borderColor  = UIColor.white.cgColor
        viewPassword.layer.borderWidth  = 1.0
        viewPassword.alpha              = 0.0
        
        btnSubmit.alpha                 = 0.0
        
        //Placeholder Color
        let attributesDictionary = [NSForegroundColorAttributeName: UIColor.white]
        
        self.txtCompany.attributedPlaceholder = NSAttributedString(string: "Company", attributes: attributesDictionary)
        self.txtUserID.attributedPlaceholder = NSAttributedString(string: "User ID", attributes: attributesDictionary)
        self.txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributesDictionary)
    }
    

    //MARK: - Start Animation
    func startAnimation() -> Void {
        //Set Constraint Constant value
        self.constraintCenterY_Logo.constant = -150
        
        UIView.animate(withDuration: 0.5, animations: {
            //Update Layout
            self.view.layoutIfNeeded()
        }) { (isFinished) in
            //Show other components with Animation
            UIView.animate(withDuration: 0.3, animations: { 
                self.viewCompany.alpha    = 1.0
                self.viewUser.alpha       = 1.0
                self.viewPassword.alpha   = 1.0
                self.btnSubmit.alpha      = 1.0
            })
        }
    }
    
    //MARK: - Submit
    @IBAction func btnSubmitClicked(_ sender: Any) {
//        //Validation
//        if (txtCompany.text?.characters.count)! <= 0 {
//            AppUtils.showAlertWithTitle(title: "", message: "Please select company.", viewController: self)
//        }else if (txtUserID.text?.characters.count)! <= 0 {
//            AppUtils.showAlertWithTitle(title: "", message: "Please provide User ID.", viewController: self)
//        }else if (txtPassword.text?.characters.count)! <= 0 {
//            AppUtils.showAlertWithTitle(title: "", message: "Please provide password.", viewController: self)
//        }else {
            //Call WS
            self.loginWS()
//        }
    }
    
    
    //MARK: - Web Services
    func loginWS() -> Void {
        //Show Loader
        //Run on main thread
        DispatchQueue.main.async {
            //AppUtils.showLoader()
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        //Navigate to Dashboard
        let dashboardVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoardIdentifier.storyDashboardVC) as! Dashboard
        
        self.navigationController?.pushViewController(dashboardVC, animated: true)
        
        //Run on main thread
        DispatchQueue.main.async {
            //AppUtils.hideLoader()
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }
    }
    
}


//MARK: - UITextField Delegate
extension Login: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 100 {
            textField.resignFirstResponder()
        }else if textField.tag == 101 {
            //Navigate to password
            self.txtPassword.becomeFirstResponder()
        }else if textField.tag == 102 {
            //Resign Keyboard
            //Set Constraint Constant value
            self.constraintCenterY_Logo.constant = -150
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
            
            return textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Open Picker if it is for Company
        if textField.tag == 100 {
            //No need of KEYBOARD for company selection
            self.txtCompany.resignFirstResponder()
            
            ActionSheetStringPicker.show(withTitle: "Select Company", rows: arrayCompany, initialSelection: indexCompanySelected, doneBlock: { (picker, indexes, values) in
                
                print("values = \(values ?? "No Values")")
                //Get and Set Value
                self.txtCompany.text = "\(values!)"
                
                //Get Selected Index
                self.indexCompanySelected = indexes
                
                //Become First Responder to USER ID
                self.txtUserID.becomeFirstResponder()
                
                return
                
            }, cancel: { (picker) in
                //Do Nothing
                return
            }, origin: textField)
        }else if textField.tag == 101 || textField.tag == 102 {
            //Set Constraint Constant value
            self.constraintCenterY_Logo.constant = -200
            
            UIView.animate(withDuration: 0.2, animations: { 
                self.view.layoutIfNeeded()
            })
        }
    }
}
