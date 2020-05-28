//
//  CustomView.swift
//  CustomView
//
//  Created by Subair Ariyil on 27/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
class ShippingIndicator : UIView{
    
    
    var circleDiameter :CGFloat = 10.0
    
    var borderWidth : CGFloat = 3.0
    
    @IBOutlet weak var leftCircle: UIView!
    @IBOutlet weak var middleCircle: UIView!
    @IBOutlet weak var rightCircle: UIView!
    
    @IBOutlet weak var leftLine: UIView!
    @IBOutlet weak var rightLine: UIView!
    
    @IBOutlet weak var circleHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var middleCircleHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rightCircleHeightConstraint: NSLayoutConstraint!
    var leftCircleColor : UIColor = UIColor.clear
    
    var leftLineColor : UIColor = UIColor.clear
    var rightLineColor : UIColor = UIColor.clear
    var middleCircleColor: UIColor = UIColor.clear
    var  rightCircleColor: UIColor = UIColor.clear
    
    var leftCircleBorderColor: UIColor = UIColor.clear
    var middleCircleBorderColor: UIColor = UIColor.clear
    var rightCircleBorderColor: UIColor = UIColor.clear
    
    var indicatorViewBackground: UIColor? = .clear
    @IBOutlet var contentView: ShippingIndicator!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        comminInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        comminInit()
    }
    
    func comminInit(){
        if self.subviews.count > 0{
            return
        }
        Bundle.main.loadNibNamed("ShippingIndicator", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = indicatorViewBackground
        applyChanges()
    }
    
    func toCircle(view : UIView){
        view.layer.cornerRadius = view.frame.size.width/2
        view.clipsToBounds = true
    }
    
    private func applyChanges(){
        leftCircle.backgroundColor = leftCircleColor
        middleCircle.backgroundColor = middleCircleColor
        rightCircle.backgroundColor = rightCircleColor
        
        leftCircle.layer.borderColor = leftCircleBorderColor.cgColor
        middleCircle.layer.borderColor = middleCircleBorderColor.cgColor
        rightCircle.layer.borderColor = rightCircleBorderColor.cgColor
        
        leftCircle.layer.borderWidth = borderWidth
         middleCircle.layer.borderWidth = borderWidth
         rightCircle.layer.borderWidth = borderWidth
        
        leftLine.backgroundColor = leftLineColor
        rightLine.backgroundColor = rightLineColor
        
       
        toCircle(view: leftCircle)
        toCircle(view: middleCircle)
        toCircle(view: rightCircle)
        
        contentView.backgroundColor = indicatorViewBackground
    }
    
    func redrawView(){
        applyChanges()
    }
}

