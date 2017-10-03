//
//  Dashboard.swift
//  Locus
//
//  Created by Mehul Solanki on 25/08/17.
//  Copyright © 2017 Mehul Solanki. All rights reserved.
//

import UIKit

class Dashboard: SuperViewController {
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set Right Bar Image
        self.showRightBarIcon()
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
