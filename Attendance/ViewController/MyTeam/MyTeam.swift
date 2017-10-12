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
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Navigation Bar Title
        self.navigationItem.title = "My Team"
        
        //Check for Location Permission
        if self.isLocationPermitted() == true {
            //Load Current Location
            //self.loadCurrentLocation()
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(loadCurrentLocation), userInfo: nil, repeats: false)
        }
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

}
