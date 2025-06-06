//
//  EventRaceClass.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 24/04/21.
//  Copyright © 2021 YaraTech. All rights reserved.
//

import Foundation
class EventClass: Codable {
    var raceID, raceName: String?
    var raceClasses: [EventRaceClass]?
    
    enum CodingKeys: String, CodingKey {
        case raceID = "race_id"
        case raceName = "race_name"
        case raceClasses = "race_classes"
    }
    
    func hasSpecialClass() -> Bool {
        if raceClasses?.count ?? 0 > 0 {
            for raceClass in raceClasses! {
                if raceClass.specialCase ?? false {
                    return true
                }
            }
        }
        return false
    }
    
    func validateRaceClasses() -> Bool {
        var isValid: Bool = true
        if raceClasses?.count ?? 0 > 0 {
            for raceClass in raceClasses! {
                raceClass.hasError = (raceClass.checked ?? false) && (raceClass.bikeData?.isEmpty ?? true)
                if raceClass.hasError {
                    isValid = false
                }
            }
        }
        return isValid
    }
    
    func hasClassSelected() -> Bool {
        if raceClasses?.count ?? 0 > 0 {
            for raceClass in raceClasses! {
                if raceClass.checked ?? false {
                    return true
                }
            }
        }
        return false
    }
    
    func canSelectSpecialClass() -> Bool {
        for raceClass in raceClasses! {
            if !(raceClass.specialCase ?? false) && (raceClass.checked ?? false) {
                return true
            }
        }
        return false
    }
    
    func validateSpecialCase(_ raceClass: EventRaceClass) {
        var hasChecked: Bool = false
        for raceClassItem in raceClasses! {
            if raceClass.classID == raceClassItem.classID {
                continue
            } else {
                if !(raceClassItem.specialCase ?? false) && (raceClassItem.checked ?? false) {
                    hasChecked = true
                }
            }
        }
        if !hasChecked {
            deselectSpecialClasses()
        }
    }
    
    func deselectSpecialClasses() {
        for raceClassItem in raceClasses! {
            if raceClassItem.specialCase ?? false {
                raceClassItem.checked = false
            }
        }
    }

    
    func getSelectedClassPrice() -> Double {
        var total: Double = 0
        for raceClass in raceClasses! {
            if raceClass.checked ?? false {
                total = total + Double(raceClass.classPrice ?? 0)
            }
        }
        return total
    }
}

class EventRaceClass: Codable {
    var classID, className: String?
    var specialCase: Bool?
    var classPrice: Int?
    var bikeData: String?
    var bikeDataValue: String?
    var checked: Bool?
    var hasError = false
    var soldOut: Bool?

    
    enum CodingKeys: String, CodingKey {
        case classID = "class_id"
        case className = "class_name"
        case specialCase = "special_case"
        case classPrice = "class_price"
        case bikeData = "bike_data"
        case checked
        case soldOut = "sold_out"
    }
}

class BikesClass: Codable {
    var key, value: String?
    enum CodingKeys: String, CodingKey {
        case key
        case value
    }
}
