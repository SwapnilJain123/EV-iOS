//
//  SignatureUpdateRequest.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 30/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct SignatureUpdateRequest: Codable {
    var signatureID: Int = 0
    var signature : String = ""

    enum CodingKeys: String, CodingKey {
        case signatureID = "signature_id"
        case signature
    }
}
