//
//  PwdResetAckController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 11/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit

class PwdResetAckController: ETViewController {
    
    var message = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageLabel.text! = message
        
        exitButton.applyColorTheme()
        
        if AppEngine.sharedInstance.isEvApp() == false{
            resetImage.image = UIImage(named: "ic_moto_action_success")
        }
       
    }
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var resetImage: UIImageView!
    
    @IBOutlet weak var exitButton: UIButton!
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_FORGOT_PASSWORD
    }
  
    @IBAction func didPressExit(_ sender: UIButton) {
       
        self.navigationController?.popToRootViewController(animated: true)
        
        
    }
    
}
