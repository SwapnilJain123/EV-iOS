//
//  ApiConstsant.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 21/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

class ApiConstants{
    
    static var BASE_URL : String {
        var nsDictionary : NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"){
             nsDictionary = NSDictionary(contentsOfFile: path)
            let baseUrl = nsDictionary!["BASE_URL"] as! String? ?? "Error!!"
            Log.i("\nBase Url \(baseUrl)")
            return "\(ProtocolHTTPS)\(baseUrl)"
        }
        return "https://evolvegt.webeteerprojects.com"
    }
    
    static let ProtocolHTTPS = "https://"
}
