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
    
    func formattedDate(outputFormat: String) -> String {
        let date = Date(fromString: self, format: .isoDate)
        let formattedDate = date?.toString(format: .custom(outputFormat)) ?? self

        return formattedDate
    }
}
