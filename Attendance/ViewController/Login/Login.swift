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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //No need to show Navigation Bar
        self.navigationController?.isNavigationBarHidden = true
        
        //Auto Login
        //Check Login data available
        if let loginID = UserDefaults.standard.value(forKey: "LOGIN_ID") as? String {
            //Login Data available
            print("Login ID : \(loginID)")
            
            //Get and Set Data
            AppUtils.APPDELEGATE().LoginID = loginID
            AppUtils.APPDELEGATE().Role = UserDefaults.standard.value(forKey: "ROLE") as! String
            AppUtils.APPDELEGATE().Name = UserDefaults.standard.value(forKey: "NAME") as! String
            AppUtils.APPDELEGATE().DepartmentName = UserDefaults.standard.value(forKey: "department_name") as! String
            AppUtils.APPDELEGATE().DesignationName = UserDefaults.standard.value(forKey: "designationname") as! String
            AppUtils.APPDELEGATE().CompanyID = UserDefaults.standard.value(forKey: "companyid") as! String
            AppUtils.APPDELEGATE().BranchID = UserDefaults.standard.value(forKey: "BRANCH_ID") as! String
            AppUtils.APPDELEGATE().imageProfile = UserDefaults.standard.value(forKey: "Image") as! String
            AppUtils.APPDELEGATE().Company = UserDefaults.standard.value(forKey: "CompanyName") as! String
            
            self.navigateToDashboard()
        }else {
            //Show Animation
            Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(startAnimation), userInfo: nil, repeats: false)
        }
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
        //Validation
        if (txtCompany.text?.characters.count)! <= 0 {
            AppUtils.showAlertWithTitle(title: "", message: "Please select company.", viewController: self)
        }else if (txtUserID.text?.characters.count)! <= 0 {
            AppUtils.showAlertWithTitle(title: "", message: "Please provide User ID.", viewController: self)
        }else if (txtPassword.text?.characters.count)! <= 0 {
            AppUtils.showAlertWithTitle(title: "", message: "Please provide password.", viewController: self)
        }else {
            //Call WS
            self.loginWS()
        }
    }
    
    
    //MARK: - Web Services
    func loginWS() -> Void {
        //Hide Keyboard
        self.view.endEditing(true)
        
        //Show Loader
        //Run on main thread
        DispatchQueue.main.async {
            //AppUtils.showLoader()
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        //Get What Company input has
        AppUtils.APPDELEGATE().Company = txtCompany.text!
        
        let userID    = txtUserID.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let password  = txtPassword.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let companyID = txtCompany.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: "https://gcell.hrdatacube.com/WebService.asmx/Login?userid=\(userID!)&password=\(password!)&company=\(companyID!)")
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data, response, error in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [AnyObject] {
                    print("\n\nLogin : \(jsonResult)\n\n")
                    //Use GCD to invoke the completion handler on the main thread
                    
                    let dictData = jsonResult.first as! [String : AnyObject]
                    if let _ = dictData["LOGIN_ID"] {
                        //Login Success
                        DispatchQueue.main.async {
                            //Get and Save information
                            AppUtils.APPDELEGATE().LoginID          = dictData["LOGIN_ID"]          as! String
                            AppUtils.APPDELEGATE().Role             = "\(dictData["ROLE"]!)"
                            AppUtils.APPDELEGATE().Name             = dictData["NAME"]              as! String
                            AppUtils.APPDELEGATE().DepartmentName   = dictData["department_name"]   as! String
                            AppUtils.APPDELEGATE().DesignationName  = dictData["designationname"]   as! String
                            AppUtils.APPDELEGATE().CompanyID        = "\(dictData["companyid"]!)"
                            AppUtils.APPDELEGATE().BranchID         = "\(dictData["BRANCH_ID"]!)"
                            AppUtils.APPDELEGATE().imageProfile     = dictData["Image"]             as! String
                            
                            //Save in USER DEFAULT
                            UserDefaults.standard.set(AppUtils.APPDELEGATE().LoginID, forKey: "LOGIN_ID")
                            UserDefaults.standard.set(AppUtils.APPDELEGATE().Role, forKey: "ROLE")
                            UserDefaults.standard.set(AppUtils.APPDELEGATE().Name, forKey: "NAME")
                            UserDefaults.standard.set(AppUtils.APPDELEGATE().DepartmentName, forKey: "department_name")
                            UserDefaults.standard.set(AppUtils.APPDELEGATE().DesignationName, forKey: "designationname")
                            UserDefaults.standard.set(AppUtils.APPDELEGATE().CompanyID, forKey: "companyid")
                            UserDefaults.standard.set(AppUtils.APPDELEGATE().BranchID, forKey: "BRANCH_ID")
                            UserDefaults.standard.set(AppUtils.APPDELEGATE().imageProfile, forKey: "Image")
                            UserDefaults.standard.set(self.txtCompany.text!, forKey: "CompanyName")
                            UserDefaults.standard.synchronize()
                            
                            //Navigate to Dashboard
                            self.navigateToDashboard()
                        }
                    }else {
                        //Error
                        let messgae = dictData["msg"] as! String
                        AppUtils.showAlertWithTitle(title: "", message: messgae, viewController: self)
                    }
                }
                
                //Run on main thread
                DispatchQueue.main.async {
                    //AppUtils.hideLoader()
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                }
                
            } catch let error as NSError {
                //Run on main thread
                DispatchQueue.main.async {
                    //AppUtils.hideLoader()
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                }
                print(error.localizedDescription)
            }
            
        }
        dataTask.resume()
        
        
        
        
        
        /*
        //Navigate to Dashboard
        let dashboardVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoardIdentifier.storyDashboardVC) as! Dashboard
        
        self.navigationController?.pushViewController(dashboardVC, animated: true)
        
        //Run on main thread
        DispatchQueue.main.async {
            //AppUtils.hideLoader()
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }
        */
    }
    
    
    //MARK: - Navigate to Dashboard
    func navigateToDashboard() -> Void {
        let dashboardVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoardIdentifier.storyDashboardVC) as! Dashboard
        
        self.navigationController?.pushViewController(dashboardVC, animated: true)
    }
    
}


//MARK: - UITextField Delegate
extension Login: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 100 {
            //textField.resignFirstResponder()
            self.txtUserID.becomeFirstResponder()
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
        /*
        //Open Picker if it is for Company
        if textField.tag == 100 {
            //No need of KEYBOARD for company selection
            self.txtCompany.resignFirstResponder()
            
            ActionSheetStringPicker.show(withTitle: "Select Company", rows: arrayCompany, initialSelection: indexCompanySelected, doneBlock: { (picker, indexes, values) in
                
                print("values = \(values ?? "No Values")")
                //Get and Set Value
                self.txtCompany.text = "\(values!)"
                
                AppUtils.APPDELEGATE().Company = values as! String
                
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
            */
            
            //Set Constraint Constant value
            self.constraintCenterY_Logo.constant = -200
            
            UIView.animate(withDuration: 0.2, animations: { 
                self.view.layoutIfNeeded()
            })
        //}
    }
}
