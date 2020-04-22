//
//  LoginResponse.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

struct LoginResponse: Decodable{
    var token: String
    var currentUser: User
}
