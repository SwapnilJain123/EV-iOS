//
//  ReferFriendViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 02/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class ReferFriendViewController: ETViewController, UITextFieldDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
        interactor.delegate = self
        emailTF.applyColorTheme()
        emailTF.addTarget(self, action: #selector(clearErrorMessage(_:)), for: .allEvents)
    }
    
    @objc func clearErrorMessage(_ textField: UITextField){
        emailTF.errorMessage = ""
    }
    override func getScreenTitle() -> String? {
        "Refer a friend"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ext.showNavbar()
        self.ext.showBackButton()
        sendInvitation.applyColorTheme()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.ext.hideNavbar()
    }
    
    let interactor = ReferFriendInteractor()
    @IBOutlet weak var sendInvitation: UIButton!
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextField!
    

    @IBAction func sendInvitationButton(_ sender: UIButton) {
        if emailTF.text?.isValidEmail() ?? false{
        interactor.ReferFriend(userID: AppEngine.sharedInstance.userID, email: emailTF.text!)
        }else{
            errorLabel.isHidden = false
        }
       
    }
    
   
    override func showAlert(title: String, message: String) {
        self.ext.showAlert(title: title, message: message, handler: {
            self.dismiss(animated: true, completion: nil)
        })
    }
}
