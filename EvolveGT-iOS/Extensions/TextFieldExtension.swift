//
//  TextFieldExtension.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 19/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import SkyFloatingLabelTextField

extension SkyFloatingLabelTextField{
    func applyColorTheme(){
        self.selectedTitleColor = .getAppThemeColor()
    }
}
