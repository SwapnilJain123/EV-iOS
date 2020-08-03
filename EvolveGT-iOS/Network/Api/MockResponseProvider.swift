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
    
    private static func postData(data: Data, completionHandler : @escaping (Data?, ApiError? )-> Void){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25, execute: {
            completionHandler(data, nil)
        })
    }
    static func  provideResponse(endPoint: String, isEvApp: Bool, completionHandler : @escaping (Data?, ApiError? )-> Void) {
       
        var path = endPoint
        path = endPoint.replacingOccurrences(of: "https://evolvegt.webeteerprojects.com/evolve-api/public/app/v3/", with: "")
         print("Mock Request - \(path)")
        var data = Data()
        switch path {
        case "user/auth":
            if testDataHolder.userType == "admin"{
                 data = readFromMockResponse(fileName: "LoginAdminUserResponse")
               
            }else{
                 data = readFromMockResponse(fileName: "LoginResponse")
            }
            
        case "user/checkTermsPolicy":
            
            if testDataHolder.userAgreed{
                 data = readFromMockResponse(fileName: "UserTermsAgreed")
            }else{
                 data = readFromMockResponse(fileName: "UserTermsNotAgreed")
            }
            
        case "admin/completedEvents":
            if testDataHolder.emptyResult{
                 data = readFromMockResponse(fileName: "EmptyResultList")
            }else if !isEvApp{
                 data = readFromMockResponse(fileName: "CompletedMotoEvents")
                
            }else{
                if testDataHolder.hasTrainings{
                     data = readFromMockResponse(fileName: "CompletedEvEventsWithTraining")
                    
                }else{
                     data = readFromMockResponse(fileName: "CompletedEventsNoTraining")
                    
                }
            }
        case "admin/eventParticipants":
            if testDataHolder.emptyEventParticipants{
                 data = readFromMockResponse(fileName: "EmptyParticipants")
            }else{
                if testDataHolder.shouldRespondWithSignUpdated{
                    data = readFromMockResponse(fileName: "SignUpdated")
                }else if testDataHolder.participantsWithNoTraining{
                    data = readFromMockResponse(fileName: "ParticipantsWithNoTraining")
                }else if testDataHolder.participantsWithNoRentals{
                    data = readFromMockResponse(fileName: "ParticipantsWithNoRentals")
                }else if testDataHolder.participantsWithNoAccessories{
                    data = readFromMockResponse(fileName: "ParticipantsWithNoAccessories")
                }else if testDataHolder.noFilter{
                    data = readFromMockResponse(fileName: "ParticipantsWithNonFilterable")
                }else {
                    data = readFromMockResponse(fileName: "EventParticipantsResponse")
                }
                
                testDataHolder.shouldRespondWithSignUpdated = testDataHolder.participantsSignUpdated
            }
            
        case "user/saveTermsPolicy":
            data = readFromMockResponse(fileName: "Success")
            
        case "admin/getSignature":
            data = readFromMockResponse(fileName: "GetSignatureResponse")
            
            
        default:
            data = readFromMockResponse(fileName: "Success")
        }
        
         postData(data: data, completionHandler: completionHandler)
    }
    
    static func processTestSetup(data: [String: String]){
         testDataHolder.shouldRespondWithSignUpdated = false
        
        
        testDataHolder.userAgreed = "true" == data["user_terms_agreed"]
        testDataHolder.userType = data["user_type"] ?? "user"
       
         testDataHolder.hasTrainings = "1" == data["has_trainings"]
         testDataHolder.emptyResult = "true" == data["empty_result"]
        testDataHolder.emptyEventParticipants = "true" == data["empty_event_participants"]
        testDataHolder.participantsWithNoTraining = "true" == data["participants_no_training"]
        testDataHolder.participantsWithNoRentals = "true" == data["participants_no_rentals"]
        testDataHolder.participantsWithNoAccessories = "true" == data["participants_no_accessories"]
        
        testDataHolder.noFilter = "true" == data["no_filter"]
        testDataHolder.participantsSignUpdated = "true" == data["sign_updated"]
        
        
    }
    
    private static let testDataHolder = TestDataHolder()
    private class TestDataHolder{
        var userAgreed: Bool = false
        var userType: String = "user"
       
        var hasTrainings: Bool = false
        var emptyResult: Bool = false
        var emptyEventParticipants = false
        
        var participantsWithNoTraining = false
        var participantsWithNoRentals = false
        var participantsWithNoAccessories = false
         var participantsSignUpdated = false
        var noFilter = false
        
        var shouldRespondWithSignUpdated = false
    }
}
