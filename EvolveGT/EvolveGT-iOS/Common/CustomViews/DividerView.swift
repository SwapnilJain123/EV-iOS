//
//  DividerView.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 17/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
class DividerView : UIView{
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupView()
    }
    
    private func setupView() {
      backgroundColor = .getAppThemeColor()
        Log.d("Divider initialized")
    }
}
