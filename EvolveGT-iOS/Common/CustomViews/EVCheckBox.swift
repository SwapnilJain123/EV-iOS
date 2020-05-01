//
//  EVCheckBox.swift
//  EvolveGT
//
//  Created by Ajeesh T S on 14/07/19.
//  Copyright © 2019 com.dev.evolve. All rights reserved.
//

import UIKit
protocol EVCheckBoxDelegate: class {
    func tappedOnBox(checkBox: EVCheckBox, selected: Bool)
}
class EVCheckBox: UIButton {
    weak var delegate: EVCheckBoxDelegate?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setImage(#imageLiteral(resourceName: "button_selected"), for: .selected)
        self.setImage(#imageLiteral(resourceName: "button_deselected"), for: .normal)
        self.addTarget(self, action: #selector(EVCheckBox.checkToggle), for: .touchUpInside)
        tintColor = UIColor.getAppThemeColor()
    }
    
    @objc open func checkToggle() {
        isSelected = !isSelected
        delegate?.tappedOnBox(checkBox: self, selected: isSelected)
    }
}
