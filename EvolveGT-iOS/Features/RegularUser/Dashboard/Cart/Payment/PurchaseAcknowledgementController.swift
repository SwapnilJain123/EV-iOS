//
//  PurchaseAcknowledgementController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 02/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class PostPurchaseController : ETViewController{
    
    @IBOutlet weak var labelThankYou: UILabel!
    @IBOutlet weak var shippingIndicator: ShippingIndicator!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var labelOrderId: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    
    var interactor : CartInteractor? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ext.hideBackButton()
        
        if let transactionId = interactor?.transactionId {
            labelOrderId.text = "#\(transactionId)"
        }
        
        labelAmount.text = String(interactor?.total ?? 0).formatToAmount()
        labelDate.text = String.getCurrentDate(format: .FORMAT_DD_MMM_YYYY)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action:#selector(self.didPressDismissButton))
    }
    
    @objc func didPressDismissButton(){
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func customizeShippingIndicator(){
        let appColor = UIColor.getAppThemeColor()
        shippingIndicator.leftCircleColor = appColor
        shippingIndicator.leftCircleBorderColor = appColor
        shippingIndicator.middleCircleColor = appColor
        shippingIndicator.middleCircleBorderColor = appColor
        
        shippingIndicator.rightCircleColor = appColor
        shippingIndicator.rightCircleBorderColor = appColor
        
        shippingIndicator.leftLineColor = appColor
        shippingIndicator.rightLineColor = appColor
        shippingIndicator.indicatorViewBackground = UIColor(hexFromString: "#F5F6F7")
        shippingIndicator.redrawView()
    }
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_PAYMENT_SUCCESS
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        btnContinue.applyColorTheme()
        let appColor = UIColor.getAppThemeColor()
        labelThankYou.textColor = appColor
        labelOrderId.textColor = appColor
        labelAmount.textColor = appColor
        customizeShippingIndicator()
    }
    
    
    @IBAction func didPressContinueButton(_ sender: Any) {
        didPressDismissButton()
    }
}
