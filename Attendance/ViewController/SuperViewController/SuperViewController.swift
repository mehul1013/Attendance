//
//  SuperViewController.swift
//  Locus
//
//  Created by Mehul Solanki on 08/08/17.
//  Copyright © 2017 Mehul Solanki. All rights reserved.
//

import UIKit
import CoreLocation


class SuperViewController: UIViewController {

    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set Right Bar Image
        self.showLeftBarIcon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Show Left Bar Icon
    func showLeftBarIcon() -> Void {
        let leftBar = UIBarButtonItem(image: UIImage(named: "Menu")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(btnMenuClicked))
        self.navigationItem.leftBarButtonItem = leftBar
    }
    
    func btnMenuClicked() -> Void {
        print("Menu Button Clicked")
    }
    


}
