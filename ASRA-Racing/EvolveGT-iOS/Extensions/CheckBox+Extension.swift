//
//  UICheckBox+Extension.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 16/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import MBRadioCheckboxButton


extension CheckboxButton {
    func applyCheckboxTheme(){
        
        self.style = .rounded(radius: 3.0)
        self.checkBoxColor = CheckBoxColor(activeColor: .getAppThemeColor(), inactiveColor: .clear, inactiveBorderColor: .gray, checkMarkColor: .white)
        self.checkboxLine = CheckboxLineStyle( checkmarkLineWidth: 2, padding: 5)
        self.backgroundColor = nil
        self.setBackgroundColor(color: .clear)
        
        if self.isEnabled == false{
            self.checkBoxColor = CheckBoxColor(activeColor: .gray, inactiveColor: .gray, inactiveBorderColor: .gray, checkMarkColor: .white)
        }
        self.setTitleColor(.darkText, for: .normal)
    }
    
    
}
extension RadioButton {
    func applyRadioButtonTheme(){
        self.radioButtonColor = RadioButtonColor(active: .getAppThemeColor(), inactive: .getSecondaryColor())
       
        self.backgroundColor = nil
        
        if self.isEnabled == false{
             self.radioButtonColor = RadioButtonColor(active: .gray, inactive: .gray)
            self.setTitleColor(.gray, for: .disabled)
        }
    }
    
    
}
