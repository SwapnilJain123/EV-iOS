//
//  SecondRegisterViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 05/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit
import MBRadioCheckboxButton

class SecondRegisterViewController: ETViewController {

    @IBOutlet weak var cbAcceptTermsAndConditions: CheckboxButton!
    var validated: Bool = false
    var interactor: RegisterInteractor?
    @IBOutlet weak var indicator: RegPhaseIndicator!
    @IBOutlet weak var secondREgisterTableView: UITableView!
    @IBOutlet weak var btnRegister: UIButton!

    @IBAction func haveAnAccountButtonPressed(_ sender: UIButton) {
        self.ext.pushViewController(storyBoard: "Main", VCIdentifier: "LoginVC")
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        if interactor!.validateProfile(){
            self.interactor!.register()
        }else{
            validated = true
            secondREgisterTableView.reloadData()
             let indexPath = IndexPath(row: 4, section: 0)
            secondREgisterTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ext.showNavbar()
         ext.showBackButton()
        secondREgisterTableView.delegate = self
        secondREgisterTableView.dataSource = self
        
        indicator.setStep2()

        interactor!.delegate = self
        btnRegister.applyColorTheme()
        
        btnRegister.isEnabled = false
        cbAcceptTermsAndConditions.delegate = self
        cbAcceptTermsAndConditions.applyCheckboxTheme()
        
        interactor?.handleCreateAccount = { isAdmin in
            if isAdmin{
                self.dashboardManager.switchToAdminDashboard()
            }else{
                self.dashboardManager.switchToUserDashboard()
            }
        }
    }
    
    @IBAction func didPressTermsAndConditions(_ sender: Any) {
        
        let vc = self.ext.getViewController(storyBoard: "Settings", VCIdentifier:"TermsAndConditionViewController") as! TermsAndConditionViewController
        vc.url = CheckoutApiConstants.TERMSANDCONDITIONS
        vc.screenTitle = ScreenTitle.TITLE_TERMS_N_CONDITIONS
        self.ext.pushViewController(viewController: vc)
    }
    override func getScreenTitle() -> String? {
           ScreenTitle.TITLE_CREATE_ACCOUNT
       }
    

}

extension SecondRegisterViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoOptionCell", for: indexPath) as! TwoOptionsCell
            
            cell.didChangeStatus = { status in
                self.interactor!.signupRequest.raceLicense = status ? 1 : 0
            }
             cell.updateUi(title: "Do you have a current race license?",  leftItemChecked: interactor!.signupRequest.raceLicense == 1)
            return cell
            
        }else if indexPath.row == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoOptionCell", for: indexPath) as! TwoOptionsCell
            
            cell.didChangeStatus = { status in
                self.interactor!.signupRequest.everBeenTrack = status ? 1 : 0
            }
             cell.updateUi(title: "Have you ever been on track?",  leftItemChecked: interactor!.signupRequest.everBeenTrack == 1)
            return cell
            
        }else if indexPath.row == 2{
            
          let cell = tableView.dequeueReusableCell(withIdentifier: RegistrationMaskedTextFieldCell.identifier, for: indexPath) as! RegistrationMaskedTextFieldCell
           
           cell.viewAction = {
               self.selectSkillLevel()
           }
           if validated{
               cell.showErrorMessage(errorMessage: ErrorMessages.skillNotSelected, hasError: self.interactor!.signupRequest.skillLevel?.isEmpty ?? true)
           }
           cell.setData(placeHolder: "Skill Level", value: interactor!.signupRequest.skillLevel ?? "", evIcon: "ic_down_arrow", motoIcon: "ic_down_arrow")
           
           return cell
        }else if indexPath.row == 3{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "checkBoxCell", for: indexPath) as! CheckBoxCell
            cell.updateUI(status: interactor!.signupRequest.subscribeForDiscounts == 1)
            cell.actionItemChecked = { itemChecked in
                self.interactor!.signupRequest.subscribeForDiscounts = itemChecked ? 1 : 0
            }
            return cell
            
            
        }
        else if indexPath.row == 4{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell", for: indexPath) as! PasswordCell
            
            cell.didChangePassword = { text in
                self.interactor!.signupRequest.password = text
            }
            cell.didChangeConfirmPassword = { text in
                self.interactor!.signupRequest.confirmPassword = text
            }
            if validated{
                cell.showErrorMessage(validPassword: self.interactor!.isPasswordValid)
            }
            cell.updateUi(password: interactor!.signupRequest.password ?? "", confirmPassword: interactor!.signupRequest.confirmPassword ?? "")
            return cell
            
        }
        
        return  UITableViewCell()
    }
    
    func selectSkillLevel(){
        
        let options = self.interactor!.signupRequest.everBeenTrack == 1 ? AppConstants.TrackYesSkillLevels : AppConstants.TrackNoSkillLevels
        self.ext.presentOptions(title: "Select Skill Level", message: "", options: options, selected: "", completionHandler: { selected in
            self.interactor!.signupRequest.skillLevel = selected
            
            let indexPath = IndexPath(row: 2, section: 0)
            self.secondREgisterTableView.reloadRows(at: [indexPath], with: .automatic)
        })
    }
}
extension SecondRegisterViewController : CheckboxButtonDelegate{
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        btnRegister.isEnabled = true
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
        btnRegister.isEnabled = false
    }
    
    
}
