//
//  ApiClient.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import Alamofire

class ApiClient{
    
    var parameters = [String: Any]()
    var header = [String : String]()
    var urlString: String = ""
    
    static let sharedInstance : ApiClient = ApiClient()
    let networkManager = NetworkReachabilityManager()!
    
    private init(){
        
    }
    func doGet(completionHandler : @escaping (Data?, ApiError?) -> Void){
        
        Alamofire.request(urlString, parameters: parameters, headers:header)
            .validate()
            .responseJSON {response in
                switch response.result{
                case .success:
                    Log.d("\n\n Response:\(String(describing: String(data: response.data!, encoding: .utf8))) \n\n")
                    completionHandler(response.data!, nil)
                case .failure(let error):
                    var apiError = ApiError()
                     apiError.errorMessage = ApiError.ERROR_GENERIC_MESSAGE
                    Log.d("Error - \(error.localizedDescription)")
                    completionHandler( nil, apiError)
                }
        }
    }
    
    
    
    func doPost(completionHandler : @escaping (Data?, ApiError?) -> Void){
        
        Log.d(urlString)
        Log.d("Params :\n \(parameters) \n")
        
        Alamofire.request(urlString, method: .post, parameters: parameters,  encoding: JSONEncoding.default, headers: header)
            .validate()
            .responseJSON {response in
                switch response.result{
                case .success:
                    Log.d("\n\n Response:\(String(describing: String(data: response.data!, encoding: .utf8))) \n\n")
                    completionHandler(response.data!, nil)
                case .failure(let error):
                    var apiError = ApiError()
                    apiError.errorMessage = ApiError.ERROR_GENERIC_MESSAGE
                           Log.d("Error - \(error.localizedDescription)")
                           completionHandler( nil, apiError)
                }
        }
    }
    
   
    
    func addAuthTokenHeader(token : String){
        header.updateValue("Bearer \(token)", forKey: "Authorization")
        
    }
    func addHeader(key: String, value: String){
        header.updateValue(value, forKey: key)
    }
    
    func addParameter(key: String, value: Any){
        parameters[key] = value
    }
    
    func replaceParameter(parameters : [String: Any]){
        self.parameters = parameters
    }
    
    var isConnectedToInternet:Bool {
        return self.networkManager.isReachable
    }
}
