//
//  ApiConstsant.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 21/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

class ApiConstants{
    
    static var BASE_URL : String {
        "\(ProtocolHTTPS)\(Config.BASE_URL)\(API_PATH)"
    }

    static var BASE_URLPaypal : String {
        "\(ProtocolHTTPS)\(Config.BASE_URL)\(API_PATHPaypal)"
    }

    static let ProtocolHTTPS = "https://"
//    static let API_PATH = "/evolve-api/public/app/v3/"
    static let API_PATH = "/ontrack-api/public/app/v3/"
    static let API_PATHPaypal = "/ontrack-api/"

}
