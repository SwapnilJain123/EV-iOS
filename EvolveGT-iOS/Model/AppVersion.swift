//
//  AppVersion.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 15/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct AppVersion: Codable {
    var iosVersion, iosVersionCode, iosStore, mode: String?

    enum CodingKeys: String, CodingKey {
        case iosVersion = "ios_version"
        case iosVersionCode = "ios_version_code"
        case iosStore = "ios_store"
        case mode
    }
}
