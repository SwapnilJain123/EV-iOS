//
//  AppModeSelector.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 02/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class AppModeSelectionController : ETViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func switchToMotoApp(_ sender: Any) {
        AppEngine.sharedInstance.switchApp(appMode: .APP_MOTO)
        launchLoginPage()
    }
    @IBAction func switchToEvApp(_ sender: Any) {
        AppEngine.sharedInstance.switchApp(appMode: .APP_EV)
        launchLoginPage()
    }
    
    func launchLoginPage(){
        
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.setNavBarStyle()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}

