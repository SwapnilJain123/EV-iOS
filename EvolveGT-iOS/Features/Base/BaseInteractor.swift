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
        }catch let DecodingError.typeMismatch(type, context)  {
            Log.e("Type '\(type)' mismatch: \(context.debugDescription)")
            Log.e("codingPath: \(context.codingPath)")
            
        }catch let DecodingError.keyNotFound(key, context)  {
            Log.e("Key '\(key)' mismatch: \(context.debugDescription)")
            Log.e("codingPath: \(context.codingPath)")
            
        }catch{
            Log.e("Json Decode error")
        }
    
        return decoded
    }
    
    func viewDidLoad(){
        
    }
}
