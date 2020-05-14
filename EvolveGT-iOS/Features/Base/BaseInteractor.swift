//
//  BaseInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class BaseInteractor{
    enum FilterType {
        case trainingType
        case month
        case eventType
        case none
    }
    
    func decodeFromJson<T: Decodable>(_ data: Data, modelType: T.Type) -> T? {
           
        var decoded : T?
        let decoder = JSONDecoder()
        do{
             decoded = try decoder.decode(modelType, from: data)
        }catch{
            Log.e("Json Decode error")
        }
    
        return decoded
    }
    
    func viewDidLoad(){
        
    }
}
