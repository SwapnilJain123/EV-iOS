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
        layer.cornerRadius = 3.0
        layer.borderWidth = 0
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.8
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
    
    func drawBorder(width: CGFloat, borderColor: UIColor){
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.cgColor
    }
    
    func setGradientBackground(startColor: UIColor, endColor:UIColor){
        
        let colorTop =  startColor.cgColor
        let colorBottom = endColor.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at:0)
        
    }
}
