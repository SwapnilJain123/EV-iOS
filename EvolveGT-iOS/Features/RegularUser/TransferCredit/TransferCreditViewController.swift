//
//  TransferCreditViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 20/04/21.
//  Copyright © 2021 YaraTech. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class TransferCreditViewController: ETViewController, TransferCreditDelegate {
    func transferredCredit() {
        self.ext.pushViewController(storyBoard: "TransferCredit", VCIdentifier: "transferSuccessVC")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tfAmount.applyColorTheme()
//        tfEmail.applyColorTheme()
        tfAmount.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)

        btnTransfer.applyColorTheme()
        
    }
    
    var interactor = TransferCreditInteractor()
    
    @IBAction func didTapTransferButton(_ sender: UIButton) {
        interactor.delegate = self
        interactor.transferCreditDelegate = self
        
        let amountText = tfAmount.text!.replacingOccurrences(of: "$", with: "")
        let transferAmount = Double(amountText) ?? 0
        
        var request = TransferAmountRequest()
        request.transferEmail = tfEmail.text
        request.userID = AppEngine.sharedInstance.userID
        request.transferAmount = "\(transferAmount)"
        
        if tfEmail.text?.isValidEmail() ?? false == false{
            errorLabel.text = "Please provide a valid email"
        }else if transferAmount <= 0{
            errorLabel.text = "Please provide a valid amount"
        }else{
            errorLabel.text = ""
            interactor.transferCredit(transferCreditRequest: request)
        }
        
    }
    @IBOutlet weak var tfAmount: SkyFloatingLabelTextField!
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var availableCreditLabel: UILabel!
    @IBOutlet weak var btnTransfer: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ext.showNavbar()
        self.ext.showBackButton()
        availableCreditLabel.text = "Availabele Credit  :\(AppEngine.sharedInstance.userDetails?.walletAmount?.formatToAmount() ?? "")"
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.ext.hideNavbar()
    }
    
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_TRANSFER_CREDIT
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {

        if let amountString = textField.text?.currencyInputFormatting() {
            tfAmount.text = amountString
        }
    }
}
