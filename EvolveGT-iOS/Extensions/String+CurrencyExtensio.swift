//
//  String+CurrencyExtensio.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 05/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

extension String{
    
    static let DEFAULT_AMOUNT = "$0.00"
    func formatToAmount() -> String{
        
        if self == "0"{
            return "$0"
        }
        let price = Double(self) ?? 0
        let doubleStr = String(format: "%.2f", price)
        
        return "$\(doubleStr)"
    }
    
    func formatToAmount(prefix: String) -> String{
        if self == "0"{
            return "\(prefix): $0"
        }
        let price = Double(self) ?? 0
        let doubleStr = String(format: "%.2f", price)
        
        return "\(prefix): $\(doubleStr)"
    }
}
