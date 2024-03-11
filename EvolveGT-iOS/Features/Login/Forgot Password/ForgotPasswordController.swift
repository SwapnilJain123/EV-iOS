//
//  ForgotPasswordController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 10/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class ForgotPasswordController: ETViewController {

    
    @IBOutlet weak var lblEmailDisclaimer: UILabel!
    @IBOutlet weak var iconForgotPassword: UIImageView!
    
    @IBOutlet weak var errorView: UILabel!
    
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnResetPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ext.showNavbar()
        self.ext.showBackButton()
        if !AppEngine.sharedInstance.isEvApp() == false{
            iconForgotPassword.image = UIImage(named: "moto_forgot_password")
        }
        tfEmail.applyColorTheme()
        errorView.text! = ""
        btnResetPassword.applyColorTheme()
        
       
        tfEmail.text! = ""
        lblEmailDisclaimer.text = "Please provide your registered email. We will send the password reset link to this email."
    }
    
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_FORGOT_PASSWORD
    }
   

    @IBAction func didPressResetPassword(_ sender: Any) {
        let interactor = ForgotPasswordInteractor()
        interactor.forgotPwdDelegate = self
        interactor.resetPassword(email: tfEmail.text!)
       
    }
}
extension ForgotPasswordController:ForgotPasswordDelegate{
    func showValidationError(errorMessage: String) {
        self.errorView.text! = errorMessage
    }
    
    func didResetPassword(message: String) {
        
       let VC =  self.ext.getViewController(storyBoard: "Main", VCIdentifier: "PasswordResetAckVC") as! PwdResetAckController
        VC.message = message
        //self.present(VC, animated: true, completion: nil)
        self.navigationController?.pushViewController(VC, animated: false)
       
    }
    
    
}
