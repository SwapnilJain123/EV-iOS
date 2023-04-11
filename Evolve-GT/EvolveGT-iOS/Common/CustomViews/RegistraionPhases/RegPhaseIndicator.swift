//
//  RegPhaseIndicator.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 07/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
class RegPhaseIndicator: UIView{
    
    
    @IBOutlet weak var circleRadius: NSLayoutConstraint!
    @IBOutlet var contentView: RegPhaseIndicator!
    
    @IBOutlet weak var lineHeight: NSLayoutConstraint!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var rightCircle: UIView!
    @IBOutlet weak var leftCircle: UIView!
    
    var circleDiameter :CGFloat = 10.0
    
    var borderWidth : CGFloat = 3.0
    
    var lineColor : UIColor = UIColor.clear
    
    
    var leftCircleColor : UIColor = UIColor.clear
    var  rightCircleColor: UIColor = UIColor.clear
    
    var leftCircleBorderColor: UIColor = UIColor.clear
    
    var rightCircleBorderColor: UIColor = UIColor.clear
    var indicatorViewBackground: UIColor? = .clear
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        if self.subviews.count > 0{
            return
        }
        
        Bundle.main.loadNibNamed("RegistraionPhases", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = indicatorViewBackground
        applyChanges()
    }
    
    func toCircle(view : UIView){
        view.layer.cornerRadius = view.frame.size.width/2
        view.clipsToBounds = true
        lineHeight.constant = 3
    }
    
    private func applyChanges(){
        leftCircle.backgroundColor = leftCircleColor
        
        rightCircle.backgroundColor = rightCircleColor
        
        leftCircle.layer.borderColor = leftCircleBorderColor.cgColor
        
        rightCircle.layer.borderColor = rightCircleBorderColor.cgColor
        
        leftCircle.layer.borderWidth = borderWidth
        
        rightCircle.layer.borderWidth = borderWidth
        
        line.backgroundColor = lineColor
        
        
        
        toCircle(view: leftCircle)
        toCircle(view: rightCircle)
        
        contentView.backgroundColor = indicatorViewBackground
    }
    
    func redrawView(){
        applyChanges()
    }
    
    func setStep1(){
        leftCircleColor = .clear
        leftCircleBorderColor = .getAppThemeColor()
        
        rightCircleColor = .getInactiveGray()
        
        lineColor = .getInactiveGray()
        indicatorViewBackground = UIColor.clear//UIColor(hexFromString: "#F5F6F7")
        
        applyChanges()
    }
    
    func setStep2(){
        leftCircleColor = .getAppThemeColor()
        leftCircleBorderColor = .getAppThemeColor()
        
        rightCircleColor = .clear
        rightCircleBorderColor = .getAppThemeColor()
        
        lineColor = .getAppThemeColor()
        indicatorViewBackground = UIColor.clear//UIColor(hexFromString: "#F5F6F7")
        
        applyChanges()
    }
}
