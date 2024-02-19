//
//  UserAcceptanceStatus.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 13/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct AgreementStatus: Codable {
    var agreed: Bool?
    var termsHTML, termsCheckbox, termsButton: String?

    enum CodingKeys: String, CodingKey {
        case agreed
        case termsHTML = "terms_html"
        case termsCheckbox = "terms_checkbox"
        case termsButton = "terms_button"
    }
}
