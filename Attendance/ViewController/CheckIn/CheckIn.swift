//
//  CheckIn.swift
//  Attendance
//
//  Created by MehulS on 02/10/17.
//  Copyright © 2017 MehulS. All rights reserved.
//

import UIKit


class Location: NSObject {
    var name: String        = ""
    var address: String     = ""
    var latitude: String    = ""
    var longitude: String   = ""
}

class CheckIn: SuperViewController {
    
    @IBOutlet weak var tableLocation: UITableView!
    
    var arrayNearByPlaces = [Location]()
    var arrayAutocomplete = [Location]()
    var isForSearch: Bool = false
    var txtSearchLocation: UITextField!
    
    var isLastCheckInAvailable: Bool = false
    
    var latitude  = "\(AppUtils.APPDELEGATE().latitude)"
    var longitude = "\(AppUtils.APPDELEGATE().longitude)"
    
    var lastLatitude  = ""
    var lastLongitude = ""
    
    var distance = "0"
    var distanceTime = "0"
    
    var sourceAddress = "Source"
    var destinationAddress = "Destination"
    
    

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Navigation Bar Title
        self.navigationItem.title = "Check In"
        
        //Right Bar Button - Search
        let btnSearch = UIBarButtonItem(image: UIImage(named: "SearchRightBar")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(btnSearchClicked))
        self.navigationItem.rightBarButtonItem = btnSearch
        
        //Get Near By Locations
        self.getNearByLocations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Search Button
    func btnSearchClicked() -> Void {
        //First remove all elements
        self.arrayAutocomplete.removeAll()
        if txtSearchLocation != nil {
            txtSearchLocation.text = ""
        }
        
        if isForSearch == false {
            //Show Search
            isForSearch = true
        }else {
            //Hide Search
            isForSearch = false
        }
        self.tableLocation.reloadData()
    }
    
    
    //MARK: - Send Current Location
    func sendCurrentLocation() -> Void {
        //Get Address from Lat Long
        self.getAddressFromLatLong()
    }
    
    
    //MARK: - Get Near By Locations
    func getNearByLocations() -> Void {
        //Run on main thread
        DispatchQueue.main.async {
            //AppUtils.showLoader()
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(AppUtils.APPDELEGATE().latitude),\(AppUtils.APPDELEGATE().longitude)&radius=100&key=\(Constants.API_KEY_GOOGLE)")
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data,response,error in
            print("anything")
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    print("\n\nNear By Places : \(jsonResult)\n\n")
                    //Use GCD to invoke the completion handler on the main thread
                    let status = jsonResult.value(forKey: "status") as? String
                    if status?.lowercased() == "ok" {
                        DispatchQueue.main.async {
                            let arrayResult = jsonResult.value(forKey: "results") as! [AnyObject]
                            for dict in arrayResult {
                                let loc = Location()
                                loc.name = dict["name"] as! String
                                loc.address = dict["vicinity"] as! String
                                
                                let geometry = dict["geometry"] as! [String: AnyObject]
                                let location = geometry["location"] as! [String: AnyObject]
                                loc.latitude = "\(location["lat"]!)"
                                loc.longitude = "\(location["lng"]!)"
                                
                                print("Name = \(loc.name)")
                                print("Address = \(loc.address)")
                                print("Latitude = \(loc.latitude)")
                                print("Longitude = \(loc.longitude)")
                                
                                self.arrayNearByPlaces.append(loc)
                            }
                            
                            self.tableLocation.reloadData()
                        }
                    }
                    //Run on main thread
                    DispatchQueue.main.async {
                        //AppUtils.hideLoader()
                        //MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        self.checkLastCheckInAvailableOrNot()
                    }
                }
            } catch let error as NSError {
                //Run on main thread
                DispatchQueue.main.async {
                    //AppUtils.hideLoader()
                    //MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    self.checkLastCheckInAvailableOrNot()
                }
                print(error.localizedDescription)
            }
            
        }
        dataTask.resume()
    }
    
    
    //MARK: - Auto Complete Places
    //MARK: - Google Autocomplete Adderss
    func getGooglePlace(strSearchText: String) -> Void {
        
        let urlwithPercentEscapes = strSearchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let strURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(urlwithPercentEscapes!)&key=\(Constants.API_KEY_GOOGLE)"
        let url = URL(string: strURL)
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data,response,error in
            print("anything")
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    print("\n\nGoogle Places : \(jsonResult)\n\n")
                    
                    //Use GCD to invoke the completion handler on the main thread
                    let status = jsonResult.value(forKey: "status") as? String
                    if status?.lowercased() == "ok" {
                        
                        let arrayResult = jsonResult.value(forKey: "predictions") as! [AnyObject]
                        
                        //Remove previous elementsd
                        self.arrayAutocomplete.removeAll()
                        
                        for dict in arrayResult {
                            let loc = Location()
                            loc.address = dict["description"] as! String
                            
                            print("Address = \(loc.address)")
                            
                            self.arrayAutocomplete.append(loc)
                        }
                        
                        DispatchQueue.main.async {
                            self.tableLocation.reloadData()
                            self.txtSearchLocation.becomeFirstResponder()
                        }
                    }
                }
            } catch let error as NSError {
                //Run on main thread
                print(error.localizedDescription)
            }
            
        }
        dataTask.resume()
    }
    
    
    
    //MARK: - Check Last Check In Available or Not
    func checkLastCheckInAvailableOrNot() -> Void {
        let strEmployeeCode = AppUtils.APPDELEGATE().LoginID
        let strCompany = AppUtils.APPDELEGATE().Company
        
        //Get Date
        let date = Date()
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "yyyy-MM-dd"
        let strDate = formatterDate.string(from: date)
        
        let strURL = "https://gcell.hrdatacube.com/WebService.asmx/lastCheckIn?empcode=\(strEmployeeCode)&comp=\(strCompany)&Date=\(strDate)"
        let url = URL(string: strURL)
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data,response,error in
            print("anything")
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [AnyObject] {
                    print("\n\nLast Check-In : \(jsonResult)\n\n")
                    
                    let dictData = jsonResult.first as! [String : AnyObject]
                    
                    if let message = dictData["msg"] {
                        //Error
                        self.isLastCheckInAvailable = false
                        //AppUtils.showAlertWithTitle(title: "", message: message as! String, viewController: self)
                        
                    }else {
                        //Success
                        DispatchQueue.main.async {
                            self.isLastCheckInAvailable = true
                            
                            //Get and Set Data
                            self.sourceAddress = dictData["destination"] as! String
                            self.lastLatitude  = dictData["lat"] as! String
                            self.lastLongitude = dictData["log"] as! String
                            
                            print("Last Latitude : \(self.lastLatitude)")
                            print("Last Longitude : \(self.lastLongitude)")
                        }
                    }
                    
                    DispatchQueue.main.async {
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    }
                }
            } catch let error as NSError {
                //Run on main thread
                print(error.localizedDescription)
                
                DispatchQueue.main.async {
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                }
            }
            
        }
        dataTask.resume()
    }
    
    
    //MARK: - Check-In User
    func checkInUser() -> Void {
        //Run on main thread
        DispatchQueue.main.async {
            //AppUtils.showLoader()
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        //If previous check in is available
        if self.isLastCheckInAvailable == true {
            //Get Distance and Travel Time
            self.getDistanceAndTravelTime()
        }else {
            //Call WS
            self.callWSToCheckIn()
        }
    }
    
    
    //MARK - Get Distance and Travel Time
    func getDistanceAndTravelTime() -> Void {
        //Current
        let lat  = String(AppUtils.APPDELEGATE().latitude)
        let long = String(AppUtils.APPDELEGATE().longitude)
        let strLocation = "\(lat),\(long)"
        
        //Last Location
        lastLatitude = lastLatitude.replacingOccurrences(of: "Optional(", with: "")
        lastLatitude = lastLatitude.replacingOccurrences(of: ")", with: "")
        
        lastLongitude = lastLongitude.replacingOccurrences(of: "Optional(", with: "")
        lastLongitude = lastLongitude.replacingOccurrences(of: ")", with: "")
        
        let strLastLocation = "\(lastLatitude),\(lastLongitude)"
        
        let strURL = "https://maps.google.com/maps/api/directions/json?origin=\(strLastLocation)&destination=\(strLocation)&sensor=false&units=metric&key=\(Constants.API_KEY_GOOGLE)"
        let url = URL(string: strURL)
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data,response,error in
            print("anything")
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    print("\n\nAddress from Lat Long : \(jsonResult)\n\n")
                    
                    let status = jsonResult.value(forKey: "status") as? String
                    if status?.lowercased() == "ok" {
                        let arrayData = jsonResult.value(forKey: "routes") as! [NSDictionary]
                        let component = arrayData.first as! [String : AnyObject]
                        
                        let legs = component["legs"] as! [NSDictionary]
                        let legsFirst = legs.first as! [String : AnyObject]
                        
                        //Distance
                        let dictDistance = legsFirst["distance"] as! [String : AnyObject]
                        self.distance = dictDistance["text"] as! String
                        print("Distance : \(self.distance)")
                        
                        //Travel Time
                        let dictTime = legsFirst["duration"] as! [String : AnyObject]
                        self.distanceTime = dictTime["text"] as! String
                        print("Duration : \(self.distanceTime)")
                        
                    }
                    
                    //Check In User
                    DispatchQueue.main.async {
                        self.callWSToCheckIn()
                    }
                }
                
            } catch let error as NSError {
                //Run on main thread
                print(error.localizedDescription)
                
                DispatchQueue.main.async {
                    //MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    
                    self.callWSToCheckIn()
                }
            }
            
        }
        dataTask.resume()
    }
    
    
    func callWSToCheckIn() -> Void {
        let strEmployeeCode = AppUtils.APPDELEGATE().LoginID
        let strCompany = AppUtils.APPDELEGATE().Company
        let strComapnyID = AppUtils.APPDELEGATE().CompanyID
        let strBranchID  = AppUtils.APPDELEGATE().BranchID
        
        //Get Date
        let date = Date()
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "yyyy-MM-dd"
        let strDate = formatterDate.string(from: date)
        
        //Get Time
        let formatterTime = DateFormatter()
        formatterTime.dateFormat = "hh:mm a"
        let strTime = formatterTime.string(from: date)
        
        //Day of Week
        let formatterWeek = DateFormatter()
        formatterWeek.dateFormat = "EEEE"
        let dayOfWeek = formatterWeek.string(from: date)
        
        
        let strURL = "https://gcell.hrdatacube.com/WebService.asmx/Check_IN?empcode=\(strEmployeeCode)&lat=\(latitude)&log=\(longitude)&logtime=\(strTime)&logday=\(dayOfWeek)&distance=\(distance)&distancetime=\(distanceTime)&description=phone&logdate=\(strDate)&origin=\(sourceAddress)&log_checkout=\(strDate)&compid=\(strComapnyID)&branchid=\(strBranchID)&checkinmode=0&destination=\(destinationAddress)&company=\(strCompany)"
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: urlwithPercentEscapes!)
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data,response,error in
            print("anything")
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [AnyObject] {
                    print("\n\nCheck-In : \(jsonResult)\n\n")
                    
                    let dictData = jsonResult.first as! [String : AnyObject]
                    
                    if let message = dictData["msg"] {
                        //Check-In Success
                        DispatchQueue.main.async {
                            //Show Alert
                            // create the alert
                            let alert = UIAlertController(title: "Check-In", message: message as? String, preferredStyle: .alert)
                            
                            // add the actions (buttons)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                // do something like...
                                self.navigationController?.popViewController(animated: true)
                            }))
                            
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else {
                        //Error
                        DispatchQueue.main.async {
                        }
                    }
                    
                    DispatchQueue.main.async {
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    }
                }
            } catch let error as NSError {
                //Run on main thread
                print(error.localizedDescription)
                
                DispatchQueue.main.async {
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                }
            }
            
        }
        dataTask.resume()
    }
    
    
    
    //MARK: - Get Lat Long from Address
    func getLatLongFromAddress() -> Void {
        //Run on main thread
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        let urlwithPercentEscapes = destinationAddress.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        
        let strURL = "https://maps.googleapis.com/maps/api/geocode/json?address=\(urlwithPercentEscapes!)&key=\(Constants.API_KEY_GOOGLE)"
        let url = URL(string: strURL)
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data,response,error in
            print("anything")
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    print("\n\nLat Long from Address : \(jsonResult)\n\n")
                    
                    let status = jsonResult.value(forKey: "status") as? String
                    if status?.lowercased() == "ok" {
                        let arrayData = jsonResult.value(forKey: "results") as! [NSDictionary]
                        let component = arrayData.first as! [String : AnyObject]
                        let geometry = component["geometry"] as? [String : AnyObject]
                        let location = geometry?["location"] as? [String : AnyObject]
                        
                        self.latitude  = String(describing: location?["lat"])
                        self.longitude = String(describing: location?["lng"])
                        
                        print("Latitude : \(self.latitude)")
                        print("Longitude : \(self.longitude)")
                    }
                    
                    //Check In User
                    DispatchQueue.main.async {
                        self.checkInUser()
                    }
                }
                
            } catch let error as NSError {
                //Run on main thread
                print(error.localizedDescription)
                
                DispatchQueue.main.async {
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                }
            }
            
        }
        dataTask.resume()
    }
    
    
    //MARK: - Get Address from Lat Long
    func getAddressFromLatLong() -> Void {
        //Run on main thread
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        let lat  = String(AppUtils.APPDELEGATE().latitude)
        let long = String(AppUtils.APPDELEGATE().longitude)
        
        let strLocation = "\(lat),\(long)"
        
        let strURL = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(strLocation)&sensor=true&key=\(Constants.API_KEY_GOOGLE)"
        let url = URL(string: strURL)
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data,response,error in
            print("anything")
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    print("\n\nAddress from Lat Long : \(jsonResult)\n\n")
                    
                    let status = jsonResult.value(forKey: "status") as? String
                    if status?.lowercased() == "ok" {
                        let arrayData = jsonResult.value(forKey: "results") as! [NSDictionary]
                        let component = arrayData.first as! [String : AnyObject]
                        
                        let address = component["formatted_address"] as? String
                        print("Address : \(address!)")
                        
                        self.destinationAddress = address!
                        
                    }
                    
                    //Check In User
                    DispatchQueue.main.async {
                        self.checkInUser()
                    }
                }
                
            } catch let error as NSError {
                //Run on main thread
                print(error.localizedDescription)
                
                DispatchQueue.main.async {
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                }
            }
            
        }
        dataTask.resume()
    }
    
}

//MARK: - UITableView Delegates
extension CheckIn: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isForSearch {
            //Search Bar
            return 44
        }else {
            //Current Location
            return 67
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isForSearch {
            //Search Bar
            let cellHeader = tableView.dequeueReusableCell(withIdentifier: "CellSearch") as! CellCheckIn
            cellHeader.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
            
            //Get Reference of UITextField
            self.txtSearchLocation = cellHeader.txtSearchLocation
            cellHeader.txtSearchLocation.delegate = self
            
            //Add Target
            cellHeader.btnCancel.addTarget(self, action: #selector(btnSearchClicked), for: .touchUpInside)
            
            return cellHeader
        }else {
            //Current Location
            let cellHeader = tableView.dequeueReusableCell(withIdentifier: "CellCurrentLocation") as! CellCheckIn
            cellHeader.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
            
            //Add Target
            cellHeader.btnSendCurrentLocation.addTarget(self, action: #selector(sendCurrentLocation), for: .touchUpInside)
            
            return cellHeader
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isForSearch {
            //Search Bar
            return arrayAutocomplete.count
        }else {
            //Current Location
            return arrayNearByPlaces.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isForSearch == true {
            let cellIdentifier = "CellAddress"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CellCheckIn
            
            let model = arrayAutocomplete[indexPath.row]
            cell.lblTitle.text = model.address
            
            cell.selectionStyle = .none
            return cell
        }else {
            let cellIdentifier = "CellSearchLocation"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CellCheckIn
            
            let model = arrayNearByPlaces[indexPath.row]
            cell.lblTitle.text = model.name
            cell.lblAddress.text = model.address
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Process Check-In
        if isForSearch == true {
            let model = arrayAutocomplete[indexPath.row]
            destinationAddress = model.address

            self.getLatLongFromAddress()
        }else {
            let model = arrayNearByPlaces[indexPath.row]
            
            latitude = model.latitude
            longitude = model.longitude
            destinationAddress = model.address
            
            self.checkInUser()
        }
    }
}


//MARK: - UITextField Delegate
extension CheckIn: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        self.getGooglePlace(strSearchText: prospectiveText)
        
        return true
    }
}

