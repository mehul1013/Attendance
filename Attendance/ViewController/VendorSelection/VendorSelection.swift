//
//  VendorSelection.swift
//  Attendance
//
//  Created by MehulS on 01/11/17.
//  Copyright © 2017 MehulS. All rights reserved.
//

import UIKit

class VendorSelection: SuperViewController {

    @IBOutlet weak var tableViewVendor: UITableView!
    
    var txtSearchLocation: UITextField!
    var arrayVendor = [NSDictionary]()
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Navigation Title
        self.navigationItem.title = "Vendor Selection"
        
        self.tableViewVendor.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Web Services
    //MARK: - Get Vendors
    func getVendors(strSearchText: String) -> Void {
        
        let urlwithPercentEscapes = strSearchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let strComapnyID = AppUtils.APPDELEGATE().CompanyID
        let strBranchID  = AppUtils.APPDELEGATE().BranchID
        let strCompany   = "Mace"
        
        let strURL = "https://gcell.hrdatacube.com/WebService.asmx/MaceGeVendorAutoSearch?prefixText=\(urlwithPercentEscapes!)&compId=\(strComapnyID)&branchId=\(strBranchID)&compname=\(strCompany)"
        let url = URL(string: strURL)
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data,response,error in
            print("anything")
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [NSDictionary] {
                    print("\n\nVendors : \(jsonResult)\n\n")
                    
                    //First Remove previous array data
                    self.arrayVendor.removeAll()
                    
                    //Get result on global array
                    self.arrayVendor = jsonResult
                    
                    DispatchQueue.main.async {
                        self.tableViewVendor.reloadData()
                        self.txtSearchLocation.becomeFirstResponder()
                    }
                }
            } catch let error as NSError {
                //Run on main thread
                print(error.localizedDescription)
            }
            
        }
        dataTask.resume()
    }
    
    
    //MARK: - Clear Button
    func btnClearClicked() -> Void {
        //First remove all elements
        self.arrayVendor.removeAll()
        
        if txtSearchLocation != nil {
            txtSearchLocation.text = ""
        }
        
        self.tableViewVendor.reloadData()
    }
}


//MARK: - UITableView Delegates
extension VendorSelection: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //Search Bar
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Search Bar
        let cellHeader = tableView.dequeueReusableCell(withIdentifier: "CellSearch") as! CellCheckIn
        cellHeader.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        
        //Get Reference of UITextField
        self.txtSearchLocation = cellHeader.txtSearchLocation
        cellHeader.txtSearchLocation.delegate = self
        
        //Add Target
        cellHeader.btnCancel.addTarget(self, action: #selector(btnClearClicked), for: .touchUpInside)
        
        return cellHeader
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayVendor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CellAddress"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CellCheckIn
        
        let model = arrayVendor[indexPath.row]
        cell.lblTitle.text = model.value(forKey: "VendorName") as? String
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Get Selected Vendor
        let vendorName = arrayVendor[indexPath.row].value(forKey: "VendorName") as! String
        print("Selected Vendor : \(vendorName)")
        
        AppUtils.APPDELEGATE().Vendor = vendorName
        
        //Process Check-In
        let checkInVC = self.storyboard?.instantiateViewController(withIdentifier: "CheckIn") as! CheckIn
        self.navigationController?.pushViewController(checkInVC, animated: true)
    }
}


//MARK: - UITextField Delegate
extension VendorSelection: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        self.getVendors(strSearchText: prospectiveText)
        
        return true
    }
}
