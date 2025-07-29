//
//  TheamResponse.swift
//  EvolveGT-iOS
//
//  Created by Swapnil Jain on 29/03/25.
//  Copyright © 2025 YaraTech. All rights reserved.
//

import Foundation

struct Sponsor: Codable {
    let id: Int
    let name: String
}


struct ThemeData: Codable {
    let bottomCaption1: String?
    let bottomCaption2: String?
    let eWaiver: String?
    let eEmailVerification: String?
    let primaryColor: String?
    let secondaryColor: String?
    let googleStoreUrl: String?
    let appStoreUrl: String?
    let appMode: String?
    let evolveRegions: [EvolveRegion]?
    let orgName: String?
    let fromAddress: String?
    let color: String?
    let logo: String?
    let termsAndConditions: String?
    let waiver: String?
    let raceOrganizationName: String?
    let raceOrganizationEmail: String?
    let licenseTitle: String?
    let payMode: String?
    let payPalClientId: String?
    let payPalSecretKey: String?
    let allSponsors: [Sponsor]?
    let trainingSelectionHeading:String
    
    enum CodingKeys: String, CodingKey {
        case bottomCaption1, bottomCaption2, eWaiver, eEmailVerification
        case primaryColor, secondaryColor, googleStoreUrl, appStoreUrl
        case appMode = "app_mode"
        case evolveRegions = "evolve_regions"
        case orgName = "org_name"
        case fromAddress = "from_address"
        case color, logo, termsAndConditions = "terms_and_conditions"
        case waiver, raceOrganizationName = "race_organization_name"
        case raceOrganizationEmail = "race_organization_email"
        case licenseTitle = "license_title"
        case payMode, payPalClientId, payPalSecretKey
        case allSponsors, trainingSelectionHeading
    }
}

struct EvolveRegion: Codable {
    let name: String?
}
