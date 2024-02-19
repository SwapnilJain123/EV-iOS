//
//  UISwitchExtension.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 15/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

extension UISwitch{
    func applySwitchTheme(){
        self.onTintColor = .getAppThemeColor()
    }
}
