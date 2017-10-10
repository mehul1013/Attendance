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
        if isForSearch == false {
            //Show Search
            isForSearch = true
        }else {
            //Hide Search
            isForSearch = false
        }
        self.tableLocation.reloadData()
    }
    
    
    //MARK: - Get Near By Locations
    func getNearByLocations() -> Void {
        //Run on main thread
        DispatchQueue.main.async {
            //AppUtils.showLoader()
        }
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(AppUtils.APPDELEGATE().latitude),\(AppUtils.APPDELEGATE().longitude)&radius=1000&key=\(Constants.API_KEY_GOOGLE)")
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
                    }
                }
            } catch let error as NSError {
                //Run on main thread
                DispatchQueue.main.async {
                    //AppUtils.hideLoader()
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

