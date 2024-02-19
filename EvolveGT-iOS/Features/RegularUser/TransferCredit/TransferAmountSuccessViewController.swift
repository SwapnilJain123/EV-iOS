//
//  TransferAmountSuccessViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 21/04/21.
//  Copyright © 2021 YaraTech. All rights reserved.
//

import UIKit

class TransferAmountSuccessViewController: ETViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        exitButton.applyColorTheme()
        
        if AppEngine.sharedInstance.isEvApp() == false{
           successImage.image = UIImage(named: "ic_moto_action_success")
        }
    }
    
    @IBOutlet weak var successImage: UIImageView!
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
        ScreenTitle.TITLE_TRANSFER_CREDIT
    }
   
    @IBAction func didTapExit(_ sender: UIButton) {
        self.dashboardManager.switchToUserDashboard()
    }
    @IBOutlet weak var exitButton: UIButton!
    
}
