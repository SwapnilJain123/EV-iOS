//
//  StackView+Extension.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 26/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
extension UIStackView {
    func setBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
