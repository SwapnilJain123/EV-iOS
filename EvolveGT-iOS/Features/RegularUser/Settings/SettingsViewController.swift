//
//  SettingsViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 14/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : ETViewController{
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var settingsContainer: UITableView!
    
    var settings = [SettingsItem]()
    let interactor = SettingsInteractor()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSave.applyColorTheme()
        
        interactor.viewDelegate = self
        interactor.settingsDelegate = self
        
        settingsContainer.delegate = self
        settingsContainer.dataSource = self
        
        interactor.getSettingsItems()
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
        ScreenTitle.TITLE_SETTINGS
    }
    
    @IBAction func didPressSaveButton(_ sender: Any) {
        if let notificationSettings = settings.first(where: {$0.settingsType == .notification}){
            interactor.updateNotificationRequest(preferences: notificationSettings.menuItems)
        }
    }
    
}
extension SettingsViewController: SettingsDelegate{
    func populateSettingsItems(settings: [SettingsItem]) {
        self.settings = settings
        settingsContainer.reloadData()
    }
}
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings[section].menuItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch settings[indexPath.section].settingsType {
        case .language:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsLanguageCell.identifier, for: indexPath) as! SettingsLanguageCell
            cell.selectionStyle = .none
            return cell
        case .notification:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsNotificationCell.identifier, for: indexPath) as! SettingsNotificationCell
            cell.populateUi(preference: settings[indexPath.section].menuItems[indexPath.row])
            cell.selectionStyle = .none
            return cell
        case .more:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsMoreActions.identifier, for: indexPath) as! SettingsMoreActions
            cell.populateUi(preference: settings[indexPath.section].menuItems[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settings[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if settings[indexPath.section].settingsType == .more{
//            let vc = self.ext.getViewController(storyBoard: "Settings", VCIdentifier:"InfoDisplayVC") as! InfoDisplayController
//            vc.contentTitle = settings[indexPath.section].menuItems[indexPath.row].title ?? ""
//            if indexPath.row == 0{
//                let vc = self.ext.getViewController(storyBoard: "Settings", VCIdentifier:"TermsAndConditionViewController") as! TermsAndConditionViewController
//                vc.url = CheckoutApiConstants.TERMSANDCONDITIONS
//                vc.screenTitle = ScreenTitle.TITLE_TERMS_N_CONDITIONS
//                self.ext.pushViewController(viewController: vc)
//                return
//            }else if indexPath.row == 1{
//                vc.text = AppConstants.PRIVACY_POLICY
//            }else{
//                vc.text = AppConstants.REFUND_POLICY
//            }
//            self.ext.pushViewController(viewController: vc)
            
            let vc = self.ext.getViewController(storyBoard: "Settings", VCIdentifier:"TermsAndConditionViewController") as! TermsAndConditionViewController
            
            if indexPath.row == 0{
                vc.url = CheckoutApiConstants.TERMSANDCONDITIONS
                vc.screenTitle = ScreenTitle.TITLE_TERMS_N_CONDITIONS
            }else if indexPath.row == 1{
                vc.url = CheckoutApiConstants.PRIVACY_POLICY
                vc.screenTitle = ScreenTitle.TITLE_PRIVACY_POLICY
            }
            self.ext.pushViewController(viewController: vc)
        }
    }
}
