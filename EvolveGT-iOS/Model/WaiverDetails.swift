//
//  WaiverDetails.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 11/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation



// MARK: - EventData
struct EventData: Codable {
    var title, hosting, date: String?
    var logo: String?
    var termsHTML, checkboxLabel, buttonText: String?

    enum CodingKeys: String, CodingKey {
        case title, hosting, date, logo
        case termsHTML = "terms_html"
        case checkboxLabel = "checkbox_label"
        case buttonText = "button_text"
    }
}

// MARK: - State
struct State: Codable {
    var code, name: String?
}

// MARK: - UserData
struct UserData: Codable {
    var firstName, lastName, dob, email: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case dob, email
    }
}
