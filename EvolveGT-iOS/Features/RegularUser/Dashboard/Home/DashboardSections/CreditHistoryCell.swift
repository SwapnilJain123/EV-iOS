//
//  CreditHistoryCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 05/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit


protocol CreditHistoryCellDelegate{
    func toggleCreditDetailsView()
    func showCreditLists()
}
class CreditHistoryCell: UITableViewCell{
    
    var delegate :CreditHistoryCellDelegate? = nil
    
    @IBOutlet weak var rootView: UIView!
    
    
    @IBOutlet weak var creditRightButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var creditAmount: UILabel?
    
    @IBOutlet weak var postedDate: UILabel!
    
    @IBOutlet weak var creditDescription: UILabel!
    @IBOutlet weak var seeMoreButton: UIButton?
    
    var normalPlusImage : UIImage? = nil
    var selectionPlusImage : UIImage? = nil
    
    var normalMinusImage : UIImage? = nil
    var selectionMinusImage : UIImage? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func applyTheme(){
//        if !AppEngine.sharedInstance.isEvApp(){
//            
//            normalPlusImage = UIImage(named: "ic_btn_plus_green")
//            selectionPlusImage = UIImage(named: "ic_btn_plus_green_lite")
//            
//            normalMinusImage = UIImage(named: "ic_btn_minus_green")
//            selectionMinusImage = UIImage(named: "ic_btn_minus_green_lite")
//            
//        }else{
//            normalPlusImage = UIImage(named: "ic_btn_plus_blue")
//            selectionPlusImage = UIImage(named: "plus_blue_lite")
//            
//            normalMinusImage = UIImage(named: "ic_btn_minus_blue")
//            selectionMinusImage = UIImage(named: "ic_btn_minus_blue_lite")
//            
//        }
        
        normalPlusImage = UIImage(named: "ic_btn_plus_blue")
        selectionPlusImage = UIImage(named: "plus_blue_lite")
        
        normalMinusImage = UIImage(named: "ic_btn_minus_blue")
        selectionMinusImage = UIImage(named: "ic_btn_minus_blue_lite")

        let appColor = UIColor.getAppThemeColor()
        creditAmount?.textColor = appColor
        seeMoreButton?.setTitleColor(appColor, for: .normal)
        
        
        creditRightButton.setImage(normalPlusImage, for: .normal)
        creditRightButton.setImage(selectionPlusImage, for: .selected)
    }
    func showData(_ credit: CreditHistory, expanded: Bool){
        applyTheme()
        
        creditRightButton.setImage(normalMinusImage, for: .normal)
        creditRightButton.setImage(selectionMinusImage, for: .selected)
        
        
        creditAmount?.text = credit.amount?.formatToAmount()
        postedDate.text = "Posted on: \(credit.postDate?.formattedDate(inputPattern: .FORMAT_API_DATE, outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
        creditDescription.text = credit.creditHistoryDescription
        
        
        rootView.setCardView()
        
    }
    
    @IBAction func didPressExpandButton(_ sender: Any) {
        delegate?.toggleCreditDetailsView()
    }
    
    @IBAction func didPressSeeMore(_ sender: Any) {
        delegate?.showCreditLists()
    }
    
}
