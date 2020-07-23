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
                  return data
              } catch {
                   // handle error
              }
        
        }
        return Data()
    }
    static func  provideResponse(endPoint: String) -> Data{
        var path = endPoint
        path = endPoint.replacingOccurrences(of: "https://evolvegt.webeteerprojects.com/evolve-api/public/app/v3/", with: "")
        
        switch path {
        case "user/auth":
            return readFromMockResponse(fileName: "LoginResponse")
        case "user/checkTermsPolicy":
                return readFromMockResponse(fileName: "UserAGreementFailed")
        case "user/saveTermsPolicy":
            return readFromMockResponse(fileName: "Success")
        default:
            return readFromMockResponse(fileName: "Success")
        }
        
    }
}
