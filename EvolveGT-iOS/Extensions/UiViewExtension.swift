//
//  UiViewExtension.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 24/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
extension UIView {

    //For Card Style
    func setCardView(){
        layer.cornerRadius = 5.0
        layer.borderColor  =  UIColor.clear.cgColor
        layer.borderWidth = 2.0
        layer.shadowOpacity = 0.5
        layer.shadowColor =  UIColor.lightGray.cgColor
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width:5, height: 5)
        layer.masksToBounds = true
    }
    
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
    
    func  showRoundCorner(roundCorner: CGFloat){
        self.layer.cornerRadius = roundCorner
        self.clipsToBounds = true
    }
    
    func showRoundCorner(){
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
    }
    
    func showRoundBorder(){
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 3.0
    }
}
