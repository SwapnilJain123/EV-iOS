//
//  UITableViewCell+Extension.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 01/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
extension UITableViewCell{
    func frameToCardView(backgroundView: UIView){
        backgroundView.layer.cornerRadius = 5.0
        backgroundView.layer.borderColor  =  UIColor.clear.cgColor
        backgroundView.layer.borderWidth = 5.0
        backgroundView.layer.shadowOpacity = 0.5
        backgroundView.layer.shadowColor =  UIColor.black.cgColor
        backgroundView.layer.shadowRadius = 5.0
        backgroundView.layer.shadowOffset = CGSize(width:5, height: 5)
        backgroundView.layer.masksToBounds = true
    }
}
