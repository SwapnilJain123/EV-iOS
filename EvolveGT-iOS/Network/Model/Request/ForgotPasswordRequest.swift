//
//  ForgotPasswordRequest.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 10/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct ForgotPasswordRequest : Encodable {
   
    var userEmail: String?

       enum CodingKeys: String, CodingKey {
           case userEmail = "user_email"
       }
}
