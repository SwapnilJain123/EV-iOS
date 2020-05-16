//
//  ChangePasswordViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 15/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit

class ChangePasswordViewController: ETViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        changePassword.applyColorTheme()

       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ext.showNavbar()
        self.ext.showBackButton()
    }
    
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_CHANGE_PASSWORD
    }
    @IBAction func changePasswordButton(_ sender: UIButton) {
    }
    @IBOutlet weak var changePassword: UIButton!
    
   

}
