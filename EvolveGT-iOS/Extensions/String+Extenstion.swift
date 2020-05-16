//
//  String+Extenstion.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 16/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
extension String {
    var htmlAttributed: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlAttributed?.string ?? ""
    }
}
