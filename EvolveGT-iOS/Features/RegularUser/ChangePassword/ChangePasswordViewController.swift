//
//  ChangePasswordViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 15/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ChangePasswordViewController: ETViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        changePassword.applyColorTheme()
        currentPasswordTF.applyColorTheme()
        newPasswordTF.applyColorTheme()
        confirmPasswordTF.applyColorTheme()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ext.showNavbar()
        self.ext.showBackButton()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.ext.hideNavbar()
    }
    
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_CHANGE_PASSWORD
    }
    @IBAction func changePasswordButton(_ sender: UIButton) {
         let changePasswordIndicator = ChangePasswordInteractor()
        changePasswordIndicator.delegate = self

        changePasswordIndicator.changePassword(currentPasswordTF.text!, newPasswordTF.text!, confirmPasswordTF.text!)
        
    
    }
    @IBOutlet weak var changePassword: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var currentPasswordTF: SkyFloatingLabelTextField!
    
    @IBOutlet weak var newPasswordTF: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPasswordTF: SkyFloatingLabelTextField!
}
extension ChangePasswordViewController:ChangePasswordDelehate{
    func changePasswordMessage(message: String) {
        errorLabel.text! = message
        
    }
    
    
}

