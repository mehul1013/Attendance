//
//  Dashboard.swift
//  Locus
//
//  Created by Mehul Solanki on 25/08/17.
//  Copyright © 2017 Mehul Solanki. All rights reserved.
//

import UIKit
import MapKit

class Dashboard: SuperViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set Right Bar Image
        self.showRightBarIcon()
        
        //Check for Location Permission
        if self.isLocationPermitted() == true {
            //Load Current Location
            //self.loadCurrentLocation()
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(loadCurrentLocation), userInfo: nil, repeats: false)
        }else {
            //Show Alert
            AppUtils.showAlertWithTitle(title: "Location Permission", message: "Please enable location service from Setting menu.", viewController: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Hide Navigation Bar
        self.navigationController?.isNavigationBarHidden = false
        
        //No Need of Default Back Button
        self.navigationItem.hidesBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Status Bar Visibility
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    //MARK: - Show Right Bar Icon
    func showRightBarIcon() -> Void {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 125, height: 44))
        imageView.image = UIImage(named: "HRDataCube")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        let rightBar = UIBarButtonItem(customView: imageView)
        self.navigationItem.rightBarButtonItem = rightBar
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
    
}
