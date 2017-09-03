//
//  UtilClass.swift
//  SIVOXI
//
//  Created by Sakir on 10/4/16.
//
//

import Foundation
import UIKit


struct UtillClass {
    
    static func isValidEmail(_ testStr:String?) -> Bool {
        
        // println("validate calendar: \(testStr)")
        
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
        
    }
    
    static func showAlert(_ title: String , message: String) -> UIAlertController
    {
        
        let alertController = UIAlertController(title:Constants.AppName, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: AlertMessages.OK_TEXT, style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
        }
        
        alertController.addAction(okAction)
        return alertController
        
    }
    
}


// Network check

struct CheckNetwork {
    
    // MARK: Reachability class
    
    static func isNetworkAvailable() -> Bool {
        
        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus = reachability.currentReachabilityStatus().rawValue;
        var isAvailable  = false;
        
        switch networkStatus {
        case (NotReachable.rawValue):
            isAvailable = false;
            break;
        case (ReachableViaWiFi.rawValue):
            isAvailable = true;
            break;
        case (ReachableViaWWAN.rawValue):
            isAvailable = true;
            break;
        default:
            isAvailable = false;
            break;
        }
        return isAvailable;
        
    }
}

func getStringFromAnyObject(_ obj : AnyObject) -> String {
    
    if let value = obj as? String {
        return value
    }else if obj is NSNull {
        return ""
    }else{
        return "\(obj)"
    }
    
}


