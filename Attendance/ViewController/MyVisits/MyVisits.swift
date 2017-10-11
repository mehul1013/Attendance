//
//  MyVisits.swift
//  Attendance
//
//  Created by MehulS on 02/10/17.
//  Copyright © 2017 MehulS. All rights reserved.
//

import UIKit

class MyVisits: SuperViewController {

    @IBOutlet weak var tableViewMyVisits: UITableView!
    
    var dictData: NSDictionary!
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //Navigation Bar Title
        self.navigationItem.title = "My Visits"
        
        //Call WS
        self.getMyVisits()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Call Web Services
    func getMyVisits() -> Void {
        //Run on main thread
        DispatchQueue.main.async {
            //AppUtils.showLoader()
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        let strEmployeeCode = "6000"
        let strCompany = "Gcell"
        
        let url = URL(string: "https://gcell.hrdatacube.com/WebService.asmx/last_checking_days?empcode=\(strEmployeeCode)&company=\(strCompany)")
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data,response,error in
            
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    print("\n\nMy Visits : \(jsonResult)\n\n")
                    
                    self.dictData = jsonResult
                    print("Data : \(self.dictData)")
                    print("\n\nKeys : \(self.dictData.count)")
                    print("\n\nFirst Key : \(self.dictData.allKeys)")
                    print("First Object : \(self.dictData.value(forKey: self.dictData.allKeys.first as! String)!)")
                    
                    
                    
                    //Run on main thread
                    DispatchQueue.main.async {
                        //AppUtils.hideLoader()
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        self.tableViewMyVisits.reloadData()
                    }
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
    }
}

//MARK: - UITableView Delegates
extension MyVisits: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 67
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellHeader = tableView.dequeueReusableCell(withIdentifier: "CellHeader") as! CellCheckIn
        cellHeader.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let key = self.dictData.allKeys[section] as? String
        cellHeader.lblDate.text = key
        
        return cellHeader
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.dictData == nil {
            return 0
        }
        return self.dictData.allKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = self.dictData.allKeys[section] as? String
        
        print("\nValue : \(self.dictData.value(forKey: key!)!)")
        
        let string = self.dictData.value(forKey: key!) as! String
        let array = string.components(separatedBy: "},") as [AnyObject]
        
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CellSearchLocation"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CellCheckIn
        
//        let key = self.dictData[indexPath.section] as? String
//        let array = self.dictData.value(forKey: key!) as? [AnyObject]
//        let data = array?[indexPath.row] as! NSDictionary
//        print("Data : \(data)")
        
//        let key = self.dictData.allKeys[indexPath.section] as? String
//        let string = self.dictData.value(forKey: key!) as! String
//        let array = string.components(separatedBy: "},") as [AnyObject]
//        let data = array[indexPath.row] as! NSDictionary
//        print("Data : \(data)")
        
        cell.selectionStyle = .none
        return cell
    }
}
