//
//  BadgeView.swift
//  EvolveGT-iOS
//
//  Created by Sonali Nagde on 04/03/24.
//  Copyright © 2024 YaraTech. All rights reserved.
//

import UIKit

class BadgeView: UIView {
   
    private var label: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Optional method to update badge text
    func setText(_ text: String) {
        label.text = text
    }
}
