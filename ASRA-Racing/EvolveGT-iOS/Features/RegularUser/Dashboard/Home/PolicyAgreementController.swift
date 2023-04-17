//
//  PolicyAgreementController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 14/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import MBRadioCheckboxButton

class PolicyAgreementController: ETViewController, CheckboxButtonDelegate, AgreementAcceptanceDelegate{
   
   
    @IBOutlet weak var agreementText: UITextView!
    
    
    func requestToAcceptPolicies(agreement: AgreementStatus) {
        
    }
    
    func userHasAcceptedConditions() {
        self.dashboardManager.switchToUserDashboard()
    }
    
    
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        btnAgreement.isEnabled = true
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
        btnAgreement.isEnabled = false
    }
    
    
    @IBOutlet weak var cbTermsAccepted: CheckboxButton!
    @IBOutlet weak var btnAgreement: UIButton!
    
    let interactor = HomeDataInteractor()
    var agreement: AgreementStatus?
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAgreement.applyColorTheme()
       
        cbTermsAccepted.isOn = false
        cbTermsAccepted.applyCheckboxTheme()
        cbTermsAccepted.delegate = self
        btnAgreement.isEnabled = cbTermsAccepted.isOn
        
        btnAgreement.setTitle(agreement?.termsButton ?? "Save Agreement", for: .normal)
        cbTermsAccepted.setTitle(agreement?.termsCheckbox ?? "I Accept to the Terms and Conditions", for: .normal)
        
        let content = agreement?.termsHTML ?? AppConstants.APP_TERMS_CONDITIONS
        //contentWebView.loadHTMLString(content, baseURL: nil)
        interactor.delegate = self
        interactor.agreementStatusDelegate = self
        
        agreementText.attributedText = content.toAttributedText(with: 17.0)
    }
    
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_TERMS_N_CONDITIONS
    }
    
    
    @IBAction func didPressSaveButton(_ sender: Any) {
        interactor.saveUserAcceptanceStatus(status: true)
    }
}
