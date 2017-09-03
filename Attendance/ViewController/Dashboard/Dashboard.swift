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
        
        //Navigation Title
        self.title = "Dashboard"
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
}
