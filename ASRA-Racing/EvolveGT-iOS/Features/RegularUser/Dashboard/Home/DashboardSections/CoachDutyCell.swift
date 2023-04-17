//
//  CoachDutyCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 13/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class CoachDutyCell: UITableViewCell{
    static let identifier = "CoachDutyCell"
    
    var action:(() -> Void)?
    @IBOutlet weak var btnCochDuties: UIButton!
    
    func setUp(action:(() -> Void)?){
        self.action = action
        btnCochDuties.applyBoarderColorTheme()
        btnCochDuties.superview?.setCardView()
    }
    @IBAction func didPressCoachDutiesButton(_ sender: Any) {
        
            self.action?()
        
    }
}

