//
//  StringValidatorExtension.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
extension String {
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func toValidatedImageUrl() -> String{
        if(self.starts(with: "http") || self.starts(with:"https")){
            return self
        }else{
            return "https://evolvegt.com/" + self
        }
    }
    
    func isEmpty() -> Bool{
        allSatisfy({ $0.isWhitespace })
    }
    
    var isNotEmpty: Bool{
        self.count > 0
    }
}
extension Optional where Wrapped == String {
  var isBlank: Bool {
    return self?.isEmpty() ?? true
  }
}
