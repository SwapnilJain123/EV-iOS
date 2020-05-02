//
//  UserDefaultHelper.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct UserDefaultHelper{
    
    static let sharedInstance = UserDefaultHelper()
    
    private let userDefaults = UserDefaults.standard
    private init (){
        
    }
    
    func saveData(key: String, value: Any){
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
        
        Log.i("Saved data for - \(key)")
    }
    
    
    func getData(key: String) -> Any?{
        return userDefaults.object(forKey: key) as Any
    }
    
    func delete(key: String) -> Void{
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }

}
