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
    
    static let ProtocolHTTPS = "https://"
    static let API_PATH = "/evolve-api/public/app/v3/"
}
