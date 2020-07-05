//
//  StringDateExtension.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 23/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import AFDateHelper
extension String{
    static let FORMAT_DD_MMM_YYYY = "dd MMM YYYY"
    static let FORMAT_API_DATE = "yyyy-MM-dd HH:mm:ss"
    static let FORMAT_MMM_YYYY = "MMM YYYY"
    static let FORMAT_MM_YYYY = "MM YYYY"
     static let FORMAT_YYYY_MM = "YYYY MM"
    static let FORMAT_YYYY_MM_DD = "yyyyMMdd"
    static let FORMAT_YYYY_MM_DD_HIPHEN = "yyyy-MM-dd"
    
    func formattedDate(outputFormat: String) -> String {
       
        let date = Date(fromString: self, format: .isoDate)
        let formattedDate = date?.toString(format: .custom(outputFormat)) ?? self
        
        return formattedDate
    }
    
    func convertToDate() -> Date? {
       
        let date = Date(fromString: self, format: .isoDate)
        return date
    }
    
    static func getCurrentDate(format: String) -> String{
        let today = Date()
        let formattedToday = today.toString(format: .custom(format))
        return formattedToday
    }
    
    func formattedDate(inputPattern: String, outputFormat: String) -> String {
       
        let date = Date(fromString: self, format: .custom(inputPattern))
        let formattedDate = date?.toString(format: .custom(outputFormat)) ?? self
        
        return formattedDate
    }
    
    func isEalierThanToday() -> Bool{
        let today = Date()
        let formattedToday = today.toString(format: .custom(.FORMAT_YYYY_MM_DD))
        
        return self.formattedDate(outputFormat: .FORMAT_YYYY_MM_DD) < formattedToday
    }
    func isEalierThanToday(dateFormat: String) -> Bool{
        let today = Date()
        let formattedToday = today.toString(format: .custom(.FORMAT_YYYY_MM_DD))
        
        return self.formattedDate(inputPattern: dateFormat, outputFormat: .FORMAT_YYYY_MM_DD) < formattedToday
    }
}
