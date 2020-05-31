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
    
    @IBOutlet weak var loginImage: UIImageView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var passwordConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var loginInteractor = LoginInteractor()
    
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var guestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if BuildScheme.isBuildQA{
            tfEmail.text! = "geevar83@gmail.com"
            tfPassword.text! = "geevar@123"
        }else{
            tfEmail.text! = ""
            tfPassword.text! = ""
        }
        tfEmail.applyColorTheme()
        loginButton.applyColorTheme()
        tfPassword.applyColorTheme()
        
        guestButton.isHidden = !AppEngine.sharedInstance.isEvApp()
        
        var image = UIImage(named: "splash_logo")
        if !AppEngine.sharedInstance.isEvApp(){
            image = UIImage(named: "moto_logo")
        }
        
        loginImage.image = image
        
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
       loginInteractor.delegate = self
        loginInteractor.doLogin(email: tfEmail.text ?? "", password: tfPassword.text ?? "")
    }
    
    @IBAction func didPressGuest(_ sender: Any) {
        let controller = UIStoryboard.init(name: "Guest", bundle: nil).instantiateViewController(withIdentifier: "GuestVC") as! GuestViewController
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension LoginViewController : LoginViewDelegate{
    
    func showLoginError(errorMessage: String) {
        self.ext.removeLoadingIndicator()
        self.ext.showAlert(title: "Login Error", message: errorMessage)
        
    }
    
    func launchAdminPage() {
       let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.launchAdminDashboard()
    }
    
    func launchUserPage() {
        Log.i("\n\n Should Launch User Dashboard \n\n")
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.launchUserDashboard()
    }
    
    func launchGuestPage() {
        
    }
    
   
    
}

