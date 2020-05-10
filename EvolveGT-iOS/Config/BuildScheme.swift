//
//  BuildScheme.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 10/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class BuildScheme{
    private static var buildMode :String {
        var nsDictionary : NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"){
             nsDictionary = NSDictionary(contentsOfFile: path)
            let mode = nsDictionary!["BUILD_CONFIG"] as! String? ?? "QA"
            Log.i("\nBUILD_CONFIG -  \(mode)")
           return  mode
        }
        return  "QA"
    }
    
    static var isBuildQA : Bool {
        return "QA" == BuildScheme.buildMode
    }
}
