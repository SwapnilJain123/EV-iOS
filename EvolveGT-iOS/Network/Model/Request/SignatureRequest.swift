//
//  SignatureRequest.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 29/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct SignatureRequest: Codable {
    var signatureID: String?

    enum CodingKeys: String, CodingKey {
        case signatureID = "signature_id"
    }
}

struct SignatureResponse: Codable {
    var signed: Int?
    var signature: String?
}
