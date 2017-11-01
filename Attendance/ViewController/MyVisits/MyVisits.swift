//
//  MyVisits.swift
//  Attendance
//
//  Created by MehulS on 02/10/17.
//  Copyright © 2017 MehulS. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class MyVisits: SuperViewController {

    @IBOutlet weak var tableViewMyVisits: UITableView!
    
    var arrayMyVisit = [AnyObject]()
    var lblNoData = UILabel()
    
    var strDate: String!
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //Navigation Bar Title
        self.navigationItem.title = "My Visits"
        
        //Remove Extra Lines
        self.tableViewMyVisits.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewMyVisits.estimatedRowHeight = 67
        
        //No Data Label
        lblNoData = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableViewMyVisits.frame.size.width, height: self.tableViewMyVisits.frame.size.height))
        lblNoData.backgroundColor = UIColor.clear
        lblNoData.textAlignment = .center
        lblNoData.text = "No data found"
        lblNoData.textColor = UIColor.black
        lblNoData.font = UIFont(name: Constants.Fonts.Roboto_Regular, size: 17.0)
        self.view.addSubview(lblNoData)
        lblNoData.isHidden = true
        
        //Get Date
        let date = Date()
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "yyyy-MM-dd"
        strDate = formatterDate.string(from: date)
        
        self.tableViewMyVisits.layoutIfNeeded()
        
        //Call WS
        self.getMyVisits(strDate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Select Date
    func btnSelectDateClicked() -> Void {
        ActionSheetDatePicker.show(withTitle: "Select Date", datePickerMode: .date, selectedDate: Date(), minimumDate: nil, maximumDate: Date(), doneBlock: { (picker, indexes, values) in
            
            print("Values : \(indexes!)")
            
            let selectedDate = indexes as! Date
            
            let formatterDate = DateFormatter()
            formatterDate.dateFormat = "yyyy-MM-dd"
            self.strDate = formatterDate.string(from: selectedDate)
            
            //Call Web Service
            self.getMyVisits(self.strDate)
            
        }, cancel: { (picker) in
            //Do Nothing
            return
        }, origin: self.view)
    }
    
    
    //MARK: - Call Web Services
    func getMyVisits(_ strDate: String) -> Void {
        print("Date : \(strDate)")
        
        //Run on main thread
        DispatchQueue.main.async {
            //AppUtils.showLoader()
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        //Clear Previous Data
        arrayMyVisit.removeAll()
        
        //Hide No Data LABEL
        self.lblNoData.isHidden = true
        
        let strEmployeeCode = AppUtils.APPDELEGATE().LoginID
        let strCompany = AppUtils.APPDELEGATE().Company
        
        let url = URL(string: "https://gcell.hrdatacube.com/WebService.asmx/lat_check_in?empcode=\(strEmployeeCode)&comp=\(strCompany)&log_date=\(strDate)")
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data,response,error in
            
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [AnyObject] {
                    print("\n\nMy Visits : \(jsonResult)\n\n")
                    
                    //Run on main thread
                    DispatchQueue.main.async {
                        
                        let dictData = jsonResult.first!
                        let message = dictData["msg"] as? String
                        
                        if message != nil {
                            //Error
                            //AppUtils.showAlertWithTitle(title: "", message: message as! String, viewController: self)
                            self.lblNoData.text = message
                            self.lblNoData.isHidden = false
                        }else {
                            //Success
                            self.lblNoData.isHidden = true
                            
                            self.arrayMyVisit = jsonResult
                            //print("Data : \(self.arrayMyVisit)")
                            
                            self.tableViewMyVisits.reloadData()
                        }
                    }
                }
                
                //Run on main thread
                DispatchQueue.main.async {
                    //AppUtils.hideLoader()
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    self.tableViewMyVisits.reloadData()
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
        
        cellHeader.btnDate.setTitle(self.strDate, for: .normal)
        cellHeader.lblDistance.text = "0 Kms"
        cellHeader.lblDistance.isHidden = true
        
        //Add Target
        cellHeader.btnDate.addTarget(self, action: #selector(btnSelectDateClicked), for: .touchUpInside)
        
        return cellHeader
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 67
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMyVisit.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CellSearchLocation"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CellCheckIn
        
        //Get Model
        let model = self.arrayMyVisit[indexPath.row] as! [String : AnyObject]
        
        //Location
        let startLocation = model["origin"] as! String
        let endLocation   = model["destination"] as! String
        
        cell.lblStartToEndLocation.text = startLocation + " - " + endLocation
        cell.lblStartToEndLocation.numberOfLines = 0
        
        //Time
        let startTime = model["log_time"] as! String
        let endTime   = model["log_checkout"] as! String
        
        cell.lblTime.text = self.getTimeFromDate(startTime) + " - " + self.getTimeFromDate(endTime)
        
        //Distance
        cell.lblDistance.text = model["distance"] as? String
        
        cell.selectionStyle = .none
        return cell
    }
    
    //Get Time from Date
    func getTimeFromDate(_ strDate: String) -> String {
        //String to Date
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "HH:mm:ss"
        
        let time = strDate.components(separatedBy: "T").last
        
        let date = formatterDate.date(from: time!)
        
        if date == nil {
            return ""
        }
        
        //Date to String
        formatterDate.dateFormat = "hh:mm a"
        let strTime = formatterDate.string(from: date!)
        
        return strTime
    }
}
