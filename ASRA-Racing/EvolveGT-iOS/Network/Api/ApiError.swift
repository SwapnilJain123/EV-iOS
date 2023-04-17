//
//  ApiError.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct ApiError{
    
    static let ERROR_GENERIC_MESSAGE = "Sorry, something went wrong, please try again in a couple minutes."
    static let ERROR_OFFLINE = "Looks like you are offline.\nPlease check the network and try again."
    
    var  errorMessage: String = ERROR_GENERIC_MESSAGE
    var errorCode: Int = 0
}
