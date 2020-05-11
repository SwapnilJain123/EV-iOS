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
    
    static let TAG_BACKGROUND = 99
    
    func setBackground(color: UIColor) {
        
        let bgView = self.subviews[0]
        if bgView.tag == UIStackView.TAG_BACKGROUND{
             bgView.backgroundColor = color
        }else{
        
            let subView = UIView(frame: bounds)
            subView.backgroundColor = color
            subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            subView.tag = UIStackView.TAG_BACKGROUND
            insertSubview(subView, at: 0)
        }
    }
}

