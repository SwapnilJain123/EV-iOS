//
//  Encodable+Extension.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 16/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
extension Encodable {
    func hasKey(for path: String) -> Bool {
        return dictionary?[path] != nil
    }
    func value(for path: String) -> Any? {
        return dictionary?[path]
    }
    var dictionary: [String: Any]? {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any]
    }
}
