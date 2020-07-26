//
//  MockResponseProvider.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 19/07/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class MockResponseProvider{
    
    private static func readFromMockResponse(fileName: String)-> Data{
        
       if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                print("Mocked Response\n \(String(data: data, encoding: .utf8)!)")
               
                  return data
              } catch {
                   // handle error
                print("Mock Response read error")
              }
        }
        return Data()
    }
    static func  provideResponse(endPoint: String, isEvApp: Bool) -> Data{
       
        var path = endPoint
        path = endPoint.replacingOccurrences(of: "https://evolvegt.webeteerprojects.com/evolve-api/public/app/v3/", with: "")
         print("Mock Request - \(path)")
        switch path {
        case "user/auth":
            if testDataHolder.userType == "admin"{
                return readFromMockResponse(fileName: "LoginAdminUserResponse")
            }else{
                return readFromMockResponse(fileName: "LoginResponse")
            }
            
        case "user/checkTermsPolicy":
            
            if testDataHolder.userAgreed{
                return readFromMockResponse(fileName: "UserTermsAgreed")
            }else{
                return readFromMockResponse(fileName: "UserTermsNotAgreed")
            }
            
        case "admin/completedEvents":
            
            if !isEvApp{
                let data = readFromMockResponse(fileName: "CompletedMotoEvents")
                return data
            }else{
                if testDataHolder.hasTrainings{
                    let data = readFromMockResponse(fileName: "CompletedEvEventsWithTraining")
                    return data
                }else{
                    let data = readFromMockResponse(fileName: "CompletedEventsNoTraining")
                    return data
                }
            }
                
        case "user/saveTermsPolicy":
            return readFromMockResponse(fileName: "Success")
        default:
            return readFromMockResponse(fileName: "Success")
        }
        
    }
    
    static func processTestSetup(data: [String: String]){
        testDataHolder.userAgreed = "true" == data["user_terms_agreed"]
        testDataHolder.userType = data["user_type"] ?? "user"
       
         testDataHolder.hasTrainings = "1" == data["has_trainings"]
    }
    
    private static let testDataHolder = TestDataHolder()
    private class TestDataHolder{
        var userAgreed: Bool = false
        var userType: String = "user"
       
        var hasTrainings: Bool = false
    }
}
