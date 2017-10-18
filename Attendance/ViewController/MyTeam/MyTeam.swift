//
//  MyTeam.swift
//  Attendance
//
//  Created by MehulS on 11/10/17.
//  Copyright © 2017 MehulS. All rights reserved.
//

import UIKit
import MapKit

class MyTeam: SuperViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var arrayData = [[String : AnyObject]]()
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Navigation Bar Title
        self.navigationItem.title = "My Team"
        
        //Check for Location Permission
        if self.isLocationPermitted() == true {
            //Load Current Location
            self.mapView.showsUserLocation = true
            
            //self.loadCurrentLocation()
            //Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(loadCurrentLocation), userInfo: nil, repeats: false)
        }
        
        //Get My Team Data
        self.getMyTeam()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Load Current Location
    func loadCurrentLocation() -> Void {
        self.mapView.showsUserLocation = true
        
        //Show in Center
        let center = CLLocationCoordinate2D(latitude: AppUtils.APPDELEGATE().latitude, longitude: AppUtils.APPDELEGATE().longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        
        //Pin to Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = center
        myAnnotation.title = "Current location"
        self.mapView.addAnnotation(myAnnotation)
    }
    
    
    //MARK: - Check In
    @IBAction func btnCheckInClicked(_ sender: Any) {
        let checkInVC = self.storyboard?.instantiateViewController(withIdentifier: "CheckIn") as! CheckIn
        self.navigationController?.pushViewController(checkInVC, animated: true)
    }
    
    //MARK: - My Visits
    @IBAction func btnMyVisitsClicked(_ sender: Any) {
        let myVisitVC = self.storyboard?.instantiateViewController(withIdentifier: "MyVisits") as! MyVisits
        self.navigationController?.pushViewController(myVisitVC, animated: true)
    }
    
    
    
    //MARK: - Call Web Services
    func getMyTeam() -> Void {
        //Run on main thread
        DispatchQueue.main.async {
            //AppUtils.showLoader()
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        let strEmployeeCode = AppUtils.APPDELEGATE().LoginID
        let strCompany = AppUtils.APPDELEGATE().Company
        let strDate = "2017-10-11"
        
        let url = URL(string: "https://gcell.hrdatacube.com/WebService.asmx/show_checkIn?empcode=\(strEmployeeCode)&company=\(strCompany)&Date=\(strDate)")
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data,response,error in
            
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String : AnyObject]] {
                    
                    self.arrayData = jsonResult
                    print("\n\nMy Visits : \(self.arrayData)\n\n")
                }
                
                //Run on main thread
                DispatchQueue.main.async {
                    //AppUtils.hideLoader()
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    
                    //Load in MAP
                    self.loadDataInMap()
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
    
    
    //MARK: - Load Data in Map
    func loadDataInMap() -> Void {
        if self.arrayData.count > 0 {
            //First Remove all Annotation
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            //Add New Annotation
            for dict in self.arrayData {
                //Get Coordinate
                let latitude  = Float(dict["lat"] as! String)
                let longitude = Float(dict["log"] as! String)
                let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude!), longitude: CLLocationDegrees(longitude!))
                
                //Pin to Current Location
                let myAnnotation: MKPointAnnotation = MKPointAnnotation()
                myAnnotation.coordinate = center
                myAnnotation.title = dict["origin"] as? String
                myAnnotation.subtitle = dict["origin"] as? String
                self.mapView.addAnnotation(myAnnotation)
            }
            
            //Centralised Map
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }

}
