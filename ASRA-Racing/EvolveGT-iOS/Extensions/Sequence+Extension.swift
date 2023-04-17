//
//  Sequence+Extension.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 26/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
