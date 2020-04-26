//
//  LoginViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 21/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

import SkyFloatingLabelTextField
class LoginViewController : ETViewController, UITextFieldDelegate{
    

    @IBOutlet weak var passwordConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var loginInteractor = LoginInteractor()
    
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfPassword: SkyFloatingLabelTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         loginInteractor.delegate = self
        
        tfEmail.text! = "support@evolvegt.com"
        tfPassword.text! = "EvolveGT750"
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        tfEmail.delegate = self
        tfEmail.returnKeyType = .done
        
        tfPassword.delegate = self
        tfPassword.returnKeyType = .done
        
        self.navigationController?.isNavigationBarHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
         
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    
    @IBAction func didPressLogin(_ sender: Any) {
       
        loginInteractor.doLogin(email: tfEmail.text ?? "", password: tfPassword.text ?? "")
    }
    
}

extension LoginViewController : LoginViewDelegate{
    func showLoginError(errorMessage: String) {
        self.showAlert(title: "Login Error", message: errorMessage)
    }
    
    func launchAdminPage() {
        Log.i("\n\n Should Launch Admin Dashboard \n\n")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Admin", bundle: nil)
        let adminViewController = storyBoard.instantiateViewController(withIdentifier: "CompletedEventsViewController") as! CompletedEventViewController
        self.navigationController?.pushViewController(adminViewController, animated: true)
        self.navigationController?.popToViewController(adminViewController, animated: true)
    }
    
    func launchUserPage() {
        Log.i("\n\n Should Launch User Dashboard \n\n")
    }
    
    func launchGuestPage() {
        
    }
    
    func showError(message: String) {
        self.showAlert(title: "Login Error", message: message)
    }
    
    func showProgressIndicator(message: String?) {
        self.addLoadingIndicator()
    }
    
    func hideProgressIndicator() {
        self.removeLoadingIndicator()
    }
    
    
}

