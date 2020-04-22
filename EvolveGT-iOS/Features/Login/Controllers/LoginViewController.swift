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
class LoginViewController : UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfPassword: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tfEmail.delegate = self
        tfEmail.returnKeyType = .done
        
        tfPassword.delegate = self
        tfPassword.returnKeyType = .done
        
        

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    
    @IBAction func didPressLogin(_ sender: Any) {
        self.addLoadingIndicator()
        let loginApi = LoginApi ()
        loginApi.setCompletionHandler{ response, error in
            self.removeLoadingIndicator()
            if error == nil{
                Log.i("Login Success - ")
                let loginResponse = response as! LoginResponse
                Log.i("Logged In By - \(loginResponse.currentUser.displayName)")
            }else{
                Log.i("Login Error - \(String(describing: error?.errorMessage)) ")
            }
        }
        loginApi.doLogin(email: tfEmail.text!, password: tfPassword.text!)
    }
    
}

