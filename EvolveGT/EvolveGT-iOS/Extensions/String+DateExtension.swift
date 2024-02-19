//
//  StringDateExtension.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 23/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

extension String{
    static let FORMAT_DD_MMM_YYYY = "dd MMM YYYY"
    static let FORMAT_API_DATE = "yyyy-MM-dd HH:mm:ss"
    static let FORMAT_MMM_YYYY = "MMM YYYY"
    static let FORMAT_MM_YYYY = "MM YYYY"
     static let FORMAT_YYYY_MM = "YYYY MM"
    static let FORMAT_YYYY_MM_DD = "yyyyMMdd"
    static let FORMAT_YYYY_MM_DD_HIPHEN = "yyyy-MM-dd"
    static let FORMAT_MMMM_YYYY_DD_HH_MM_SS = "MMMM dd, yyyy HH:mm:ss"
    
    
    private func convert(fromDateFormat: String, toDateFormat: String) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromDateFormat

        if let fromDateObject = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = toDateFormat
            let newDateString = dateFormatter.string(from: fromDateObject)
            return newDateString
        }

        return self
    }

    
    
    func createDate(inPattern: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inPattern

        return dateFormatter.date(from: self) ?? Date()
    }
    
    static func getCurrentDate(format: String) -> String{
        let today = Date()
        let formattedToday = today.toString(outputPattern: format)
        return formattedToday
    }
    
    func formattedDate(inputPattern: String, outputFormat: String) -> String {
        return convert(fromDateFormat: inputPattern, toDateFormat: outputFormat)
    }
    
   
    func isEalierThanToday(dateFormat: String) -> Bool{
       let today = Date().toString(outputPattern: .FORMAT_YYYY_MM_DD)
        let date = createDate(inPattern: dateFormat).toString(outputPattern: .FORMAT_YYYY_MM_DD)
        
        return today > date
    }
    
}
extension Date{
     
    func toString(outputPattern: String) -> String{
        let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = outputPattern
       let newDateString = dateFormatter.string(from: self)
       return newDateString
               
    }
    
    static func createDateFrom(year: Int, month: Int, day: Int) -> Date? {
           let calendar = Calendar(identifier: .gregorian)
           var dateComponents = DateComponents()
           dateComponents.year = year
           dateComponents.month = month
           dateComponents.day = day
           return calendar.date(from: dateComponents) ?? nil
       }
}
