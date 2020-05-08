//
//  EmptyCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 05/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class EmptyCell: UITableViewCell{
    
    @IBOutlet weak var typeTitle: UILabel!
    @IBOutlet weak var errorMessage: UILabel!
    
    
    func showData(_ title: String, _ message: String){
        typeTitle.text = title
        errorMessage.text = message
    }
}
