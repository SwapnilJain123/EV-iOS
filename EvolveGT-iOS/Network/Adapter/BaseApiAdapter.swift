//
//  BaseApiAdapter.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation


class BaseApiAdapter{
    
    enum Method{
        case GET
        case POST
    }
    
    var completionHandler : ((Data?, ApiError?) -> Void)? = nil
    
    var requestBody : Data?
    private let apiClient = ApiClient.sharedInstance
    
    
    init(){
        apiClient.addHeader(key: "Content-Type", value: "application/json")
        if AppEngine.sharedInstance.isUserLoggedIn(){
            apiClient.addHeader (key: "Authorization", value: "Bearer \(AppEngine.sharedInstance.authToken)")
            
        }
    }
    
    func setCompletionHandler( completionHandler : @escaping (Data?, ApiError? )-> Void){
        self.completionHandler = completionHandler
    }
    
    func setUrl(url : String){
        apiClient.urlString = url
    }
    
    func setParameters(parameters : [String: Any]){
        apiClient.replaceParameter(parameters: parameters)
    }
    
    func didFail(error: ApiError) {
        Log.e(error)
        if completionHandler != nil {
            completionHandler!(nil, error)
        }
    }
    
    
    private func doPost(){
        if apiClient.uploadData.count > 0{
            apiClient.doUpload(completionHandler: didFinishTask(data:error:))
        }else{
            apiClient.doPost(completionHandler: didFinishTask(data:error:))
        }
        
    }
    
    private func doGet(){
        apiClient.doGet(completionHandler: didFinishTask(data:error:))
    }
    
    func makeRequest(method: Method){
        
        if BuildScheme.uiTestingOn{
            MockResponseProvider.provideResponse(endPoint: self.apiClient.urlString, isEvApp: AppEngine.sharedInstance.isEvApp(), completionHandler: self.didFinishTask(data:error:))
            
        }else{
            Log.i(apiClient.urlString)
            if(!apiClient.isConnectedToInternet){
                var error = ApiError()
                error.errorMessage = ApiError.ERROR_OFFLINE
                didFail(error: error)
                return
            }
            switch method {
            case .GET:
                doGet()
            case .POST:
                doPost()
            }
        }
    }
}
extension BaseApiAdapter{
    func didFinishTask(data: Data?, error : ApiError?) -> Void{
        
        if(error != nil){
            didFail(error: error!)
        }else{
            if let safeData = data{
                let decoder = JSONDecoder()
                do{
                    let etResponse = try decoder.decode(ETResponse.self, from: safeData)
                    if etResponse.status == 1{
                        if completionHandler != nil {
                            completionHandler!(safeData, nil)
                        }
                    }else{
                        
                        var error = ApiError()
                        error.errorCode = etResponse.status ?? 0
                        error.errorMessage = etResponse.msg ?? ApiError.ERROR_GENERIC_MESSAGE
                        didFail(error: error)
                    }
                    
                }catch let DecodingError.typeMismatch(type, context)  {
                    Log.e("Type '\(type)' mismatch: \(context.debugDescription)")
                    Log.e("codingPath: \(context.codingPath)")
                    var error = ApiError()
                    error.errorMessage = ApiError.ERROR_GENERIC_MESSAGE
                    didFail(error: error)
                } catch{
                    var error = ApiError()
                    error.errorMessage = ApiError.ERROR_GENERIC_MESSAGE
                    didFail(error: error)
                }
            }
        }
        
    }
    
    func makeJSONData<T: Encodable>(_ value: T) -> Data {
        Log.d("Dictonary - \(makeDictionary(value))")
        var jsonData = Data()
        var encodedData = Data()
        let jsonEncoder = JSONEncoder()
        // jsonEncoder.outputFormatting = .prettyPrinted
        
        do {
            jsonData = try jsonEncoder.encode(value)
            let data = String(data: jsonData, encoding: .utf8)?
                .data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            let dataText = String(data: data!, encoding: .utf8)
            print("Encoded Json - \(String(describing: dataText))")
            encodedData = dataText!.data(using: .utf8) ?? Data()
            
        }catch let DecodingError.typeMismatch(type, context)  {
            Log.e("Type '\(type)' mismatch: \(context.debugDescription)")
            Log.e("codingPath: \(context.codingPath)")
            var error = ApiError()
            error.errorMessage = ApiError.ERROR_GENERIC_MESSAGE
            didFail(error: error)
        }
        catch {
            Log.e("Json encode error")
        }
        return encodedData
    }
    
    
    
    func makeDictionary<T: Encodable>(_ value: T) -> [String: Any]{
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(value)
            let data = String(data: jsonData, encoding: .utf8)?
                .data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            if let dataText = data {
                do {
                    return try (JSONSerialization.jsonObject(with: dataText, options: []) as? [String: Any])!
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        } catch {
            Log.e("Json encode error")
        }
        return ["":""]
        
    }
    
    func clearUploadItems(){
        apiClient.uploadData.removeAll()
    }
    func appendUploadItem(uploadItem: UploadItem){
        apiClient.uploadData.append(uploadItem)
    }
}
