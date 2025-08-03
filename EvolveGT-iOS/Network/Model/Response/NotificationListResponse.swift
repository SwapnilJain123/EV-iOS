//
//  NotificationListResponse.swift
//  EvolveGT-iOS
//
//  Created by Sonali Nagde on 09/02/25.
//  Copyright © 2025 YaraTech. All rights reserved.
//


struct NotificationListResponse: Codable {
    let status: Int?
    let results: [NotificationItem]?
    let pageNumber: Int?
    let pages: Int?
    let msg: String?
    
    enum CodingKeys: String, CodingKey {
        case status, results, pages, msg
        case pageNumber = "page_number"
    }
}

struct NotificationItem: Codable {
    let tags: String?
    let notification: String?
    let url: String?
    let time: String?
}
