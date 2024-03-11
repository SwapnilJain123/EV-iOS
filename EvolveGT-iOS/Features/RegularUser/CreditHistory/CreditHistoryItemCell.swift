//
//  CreditHistoryCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 09/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
class CreditHistoryItemCell : UITableViewCell{
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var creditAmount: UILabel!
    @IBOutlet weak var postedDate: UILabel!
    @IBOutlet weak var creditIcon: UIImageView!
    @IBOutlet weak var creditDescription: UILabel!
    
    func showData(creditItem: CreditHistory){
        creditAmount.textColor = .getAppThemeColor()
        creditAmount.text = creditItem.amount?.formatToAmount() ?? ""
        postedDate.text = "Posted on: \(creditItem.postDate?.formattedDate(inputPattern: .FORMAT_API_DATE, outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
        creditDescription.text = creditItem.creditHistoryDescription
        
        if !AppEngine.sharedInstance.isEvApp(){
            creditIcon.image = UIImage(named: "wallet")
        }else{
            creditIcon.image = UIImage(named: "moto_wallet")
        }
        containerView.setCardView()
    }
    
}
