//
//  LoginViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 21/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController{
    
    override func viewDidLoad() {
        var nsDictionary : NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"){
            nsDictionary = NSDictionary(contentsOfFile: path)
            let appName = nsDictionary!["APP_NAME"] as! String? ?? "Error!!"
            Log.i("\n\nAPP Name IS \(appName)")
            
            let baseUrl = nsDictionary!["BASE_URL"] as! String? ?? "Error!!"
            Log.i("\n\nBase Url IS \(baseUrl)")
        }
        
    }
}

