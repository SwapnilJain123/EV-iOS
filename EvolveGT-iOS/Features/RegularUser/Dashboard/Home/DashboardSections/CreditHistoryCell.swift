//
//  CreditHistoryCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 05/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class CreditHistoryCell: UITableViewCell{
    
    @IBOutlet weak var creditRightButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var creditAmount: UILabel!
    
    @IBOutlet weak var postedDate: UILabel!
    
    @IBOutlet weak var creditDescription: UILabel!
    @IBOutlet weak var seeMoreButton: UIButton!
    
    func showData(_ credit: CreditHistory){
        creditAmount.text = credit.amount?.formatToAmount()
        postedDate.text = "Posted on: \(credit.postDate?.formattedDate(inputPattern: .FORMAT_API_DATE, outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
        creditDescription.text = credit.creditHistoryDescription
    }
}
