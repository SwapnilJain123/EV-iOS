//
//  LoginViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 21/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import FirebaseMessaging

import SkyFloatingLabelTextField
class LoginViewController : ETViewController, UITextFieldDelegate{
    
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var loginImage: UIImageView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var passwordConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var loginInteractor = LoginInteractor()
    
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var guestButton: UIButton!
    var eyeIconClick: Bool = true
    let showHiddenBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if BuildScheme.isBuildQA{
            tfEmail.text! = ""//geevar83@gmail.com"
            tfPassword.text! = ""//geevar@123"
        }else{
            tfEmail.text! = ""
            tfPassword.text! = ""
        }
        
        tfPassword.rightView = showHiddenBtn
        tfPassword.rightViewMode = .always
        showHiddenBtn.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        showHiddenBtn.addTarget(self, action: #selector(eyesButtonTapped), for: .touchUpInside)

        
        tfEmail.applyColorTheme()
        loginButton.applyColorTheme()
        tfPassword.applyColorTheme()
        btnSignUp.setTitleColor(.getAppThemeColor(), for: .normal)
        guestButton.isHidden = !AppEngine.sharedInstance.isEvApp()
        
        var image = UIImage(named: "splash_logo")
        if !AppEngine.sharedInstance.isEvApp(){
            image = UIImage(named: "moto_logo")
        }
        loginImage.image = image
    }
    
    @objc func eyesButtonTapped(_ sender: UIButton) {
        if eyeIconClick {
            tfPassword.isSecureTextEntry = false
            showHiddenBtn.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)

        } else {
            tfPassword.isSecureTextEntry = true
            showHiddenBtn.setImage(UIImage(systemName:"eye.fill"), for: .normal)

        }
        eyeIconClick = !eyeIconClick
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
       loginInteractor.loginViwelegate = self
        loginInteractor.doLogin(email: tfEmail.text ?? "", password: tfPassword.text ?? "")
    }
    
    @IBAction func didPressedCreateAccount(_ sender: UIButton) {
        
        self.ext.pushViewController(storyBoard: "Register", VCIdentifier: "fistRegisterVC")
    }
    
    
    @IBAction func didPressGuest(_ sender: Any) {
        let controller = UIStoryboard.init(name: "Guest", bundle: nil).instantiateViewController(withIdentifier: "GuestVC") as! GuestViewController
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func didPressForgotPassword(_ sender: Any) {
        
        self.ext.pushViewController(storyBoard: "Main", VCIdentifier: "ForgotPasswordVC")
    }
}

extension LoginViewController : LoginViewDelegate{
    
    func showLoginError(errorMessage: String) {
        self.ext.removeLoadingIndicator()
        self.ext.showAlert(title: "Login Error", message: errorMessage)
        
    }
    
    func launchAdminPage() {
        messagingToken()
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.launchAdminDashboard()
    }
    
    func launchUserPage() {
        Log.i("\n\n Should Launch User Dashboard \n\n")
        messagingToken()
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.launchUserDashboard(payload: nil)
    }
    
    func launchGuestPage() {
        
    }
    
    func messagingToken() {
        DispatchQueue.main.async() {
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("Error fetching remote instance ID: \(error)")
                } else if let token = token {
                    print("Firebase registration token (didBecomeActive): \(token)")
                    UserDefaults.standard.set(token, forKey: AppConstants.DEVICE_TOKEN)
                    UserDefaults.standard.synchronize()
                    let interactor = HomeDataInteractor()
                    interactor.updateDeviceToken()
                }
            }
        }
    }
   
    
}

