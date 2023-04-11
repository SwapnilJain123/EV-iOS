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
    var uploadData = [UploadItem]()
    static let sharedInstance : ApiClient = ApiClient()
    let networkManager = NetworkReachabilityManager()!
    
    private init(){
        
    }
    
    private func printHeaders(){
        for headerItem in header{
            Log.i("Key: \(headerItem.key) - Value:\(headerItem.value)")
        }
    }
    func doGet(completionHandler : @escaping (Data?, ApiError?) -> Void){
        printHeaders()
        print(parameters)
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
        printHeaders()
        Log.d(urlString)
        
        if BuildScheme.isBuildQA{
            //print the params
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: parameters, options: [.prettyPrinted]) {
                let theJSONText = String(data: theJSONData, encoding: .ascii)
                Log.d("Params :\n\n \(theJSONText!)\n\n")
            }
        }
        print(parameters)

        Alamofire.request(urlString, method: .post, parameters: parameters,  encoding: JSONEncoding.default, headers: header)
            .validate()
            .responseJSON {response in
                switch response.result{
                case .success:
                    print(response.data)
                    print(response)

                    Log.d("\n\n Response:\(String(describing: String(data: response.data!, encoding: .utf8))) \n\n")
                    completionHandler(response.data!, nil)
                case .failure(let error):
                    var apiError = ApiError()
                    apiError.errorMessage = ApiError.ERROR_GENERIC_MESSAGE
                    print("Error - \(error.localizedDescription)")

                    Log.d("Error - \(error.localizedDescription)")
                    completionHandler( nil, apiError)
                }
        }
    }
    
    
    func doUpload(completionHandler : @escaping (Data?, ApiError?) -> Void){
        printHeaders()
        if uploadData.count == 0{
            var apiError = ApiError()
            apiError.errorMessage = ApiError.ERROR_GENERIC_MESSAGE
            completionHandler( nil, apiError)
            return
        }
        Log.d(urlString)
        
        header.updateValue("multipart/form-data", forKey: "Content-type")
        
        if BuildScheme.isBuildQA{
            //print the params
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: parameters, options: [.prettyPrinted]) {
                let theJSONText = String(data: theJSONData, encoding: .ascii)
                Log.d("Params :\n\n \(theJSONText!)\n\n")
            }
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key,value) in self.parameters {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }
            for uploadItem in self.uploadData{
                multipartFormData.append(uploadItem.data, withName: uploadItem.name, fileName: uploadItem.fileName, mimeType: uploadItem.mimeType)
            }
            
        }, usingThreshold: UInt64.init(), to: urlString, method: .post, headers: header) { result in
            self.uploadData.removeAll()
            switch result{
             case .success(let upload, _, _):
                upload.responseJSON { response in
                    completionHandler(response.data!, nil)
                }
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
class UploadItem {
    var data: Data
    var name: String
    var fileName: String
    var mimeType: String
    
    init(data: Data, name: String, fileName: String, mimeType: String) {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
    
    
}
