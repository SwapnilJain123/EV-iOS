//
//  AboutUsViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 15/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit

class AboutUsViewController: ETViewController, AboutUsInteractorDelegate{
    func getAppVersionUpdateMessage(message: String) {
        updateLabel.text! = message
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabel.text! = ""
        let aboutUsInteractor = AboutUsInteractor()
        aboutUsInteractor.aboutUselegate = self
        aboutUsInteractor.checkAppVersionUpdate()
        
       

        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = BuildScheme.getBuildVersion()
        versionLabel.text! = "Version \(version)"

       
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
        ScreenTitle.TITLE_ABOUT_US
    }
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var updateLabel: UILabel!
    

}
