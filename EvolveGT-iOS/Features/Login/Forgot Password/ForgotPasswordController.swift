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

    
    @IBOutlet weak var iconForgotPassword: UIImageView!
    
    @IBOutlet weak var errorView: UILabel!
    
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnResetPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ext.showNavbar()
        self.ext.showBackButton()
        
        errorView.text! = ""

          
    }
    
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_FORGOT_PASSWORD
    }
   

    @IBAction func didPressResetPassword(_ sender: Any) {
        let interactor = ForgotPasswordInteractor()
        interactor.delegate = self
        interactor.resetPassword(email: tfEmail.text!)
       
    }
}
extension ForgotPasswordController:ForgotPasswordDelegate{
    func showValidationError(errorMessage: String) {
        self.errorView.text! = errorMessage
    }
    
    func didResetPassword(message: String) {
        self.ext.showAlert(title: "Success", message: "Password Reset")
    }
    
    
}
