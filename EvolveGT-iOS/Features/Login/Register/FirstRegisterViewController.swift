//
//  FirstRegisterViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 05/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import DatePickerDialog

class FirstRegisterViewController:ETViewController {
    
    let interactor = RegisterInteractor()
    var validated : Bool = false;
    
    var isMale: Bool = false
    var isFmale: Bool = false
    var isUnspecified: Bool = true
    
    @IBOutlet weak var myTable: UITableView!

    @IBOutlet weak var indicator: RegPhaseIndicator!
    @IBAction func didPressNextButton(_ sender: UIButton) {
        
        if interactor.validatePersonalData(){
            let vc =  self.ext.getViewController(storyBoard: "Register", VCIdentifier: "secondRegisterVC")as! SecondRegisterViewController
            vc.interactor = self.interactor
            self.ext.pushViewController(viewController: vc)
        }else{
            validated = true
            registerTableView.reloadData()
        }
    }
    
    @IBAction func haveAnAccountButtonPressed(_ sender: UIButton) {
        
        self.ext.pushViewController(storyBoard: "Main", VCIdentifier: "LoginVC")
        
    }
    
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ext.showNavbar()
        ext.showBackButton()
        registerTableView.delegate = self
        registerTableView.dataSource = self
        
        btnNext.applyColorTheme()
        indicator.setStep1()
        
        
    }
    
    @IBOutlet weak var registerTableView: UITableView!
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_CREATE_ACCOUNT
    }
    
    
}
extension FirstRegisterViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: RegistrationTextFieldCell.identifier, for: indexPath) as! RegistrationTextFieldCell
            
            
            cell.didChangeValue = {text in
                self.interactor.signupRequest.firstname = text
            }
            cell.setData(placeHolder: "First Name", value: self.interactor.signupRequest.firstname ?? "")
            if validated{
                cell.showErrorMessage(errorMessage: ValidationErrors.emptyFirstName, hasError: self.interactor.signupRequest.firstname?.isEmpty ?? true)
            }
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: RegistrationTextFieldCell.identifier, for: indexPath) as! RegistrationTextFieldCell
            
            cell.didChangeValue = { text in
                self.interactor.signupRequest.lastname = text
            }
            
            if validated{
                cell.showErrorMessage(errorMessage: ValidationErrors.emptyLastName,hasError: self.interactor.signupRequest.lastname?.isEmpty ?? true)
            }
            cell.setData(placeHolder: "Last Name", value: self.interactor.signupRequest.lastname ?? "")
            
            return cell
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: RegistrationTextFieldCell.identifier, for: indexPath) as! RegistrationTextFieldCell
            
            cell.didChangeValue = { text in
                self.interactor.signupRequest.email = text
                self.interactor.signupRequest.confirmEmail = text
            }
            if validated{
                cell.showErrorMessage(errorMessage: ValidationErrors.invalidEmail, hasError: self.interactor.signupRequest.email?.isValidEmail() ?? false == false)
            }
            cell.setData(placeHolder: "Email", value: self.interactor.signupRequest.email ?? "")
            return cell
        }else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: RegistrationMaskedTextFieldCell.identifier, for: indexPath) as! RegistrationMaskedTextFieldCell
            
            cell.viewAction = {
                self.selectDateOfBirth()
            }
            if validated{
                cell.showErrorMessage(errorMessage: ValidationErrors.invalidDoB, hasError: self.interactor.signupRequest.dob?.isEmpty ?? true)
            }
            cell.setData(placeHolder: "Date of Birth", value: interactor.signupRequest.dob ?? "", evIcon: "calendar", motoIcon: "ic_moto_calendar")
            
            return cell
            
        }else if indexPath.row == 4{
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"TwoOptionsFirestCell",for: indexPath) as! TwoOptionsFirestCell
            if self.isMale {
                cell.imgMale.image = UIImage(systemName: "circle.inset.filled")
                cell.imgFMale.image = UIImage(systemName: "circle")
                cell.imgUnspecified.image = UIImage(systemName: "circle")
            } else if self.isFmale {
                cell.imgFMale.image = UIImage(systemName: "circle.inset.filled")
                cell.imgMale.image = UIImage(systemName: "circle")
                cell.imgUnspecified.image = UIImage(systemName: "circle")
            } else if self.isUnspecified {
                cell.imgUnspecified.image = UIImage(systemName: "circle.inset.filled")
                cell.imgMale.image = UIImage(systemName: "circle")
                cell.imgFMale.image = UIImage(systemName: "circle")
            }
            
            cell.btnMale.addTarget(self, action: #selector(selectedMale), for: .touchUpInside)
            cell.btnFMale.addTarget(self, action: #selector(selectedFemale), for: .touchUpInside)
            cell.btnUnspecified.addTarget(self, action: #selector(selectedUnspecified), for: .touchUpInside)

//            cell.leftItemTitle = "Male"
//             cell.rightItemTitle = "Female"
//            cell.didChangeStatus = { status in
//                self.interactor.signupRequest.gender = status ? "Male" : "Female"
//            }
//            cell.updateUi(title: "Gender", leftItemChecked: interactor.signupRequest.gender?.lowercased() == "male")
            return cell
            
        }else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: RegistrationTextFieldCell.identifier, for: indexPath) as! RegistrationTextFieldCell
            
            cell.didChangeValue = { text in
                self.interactor.signupRequest.phone = text
            }
            if validated{
                cell.showErrorMessage(errorMessage: ValidationErrors.invalidPhoneNumber, hasError: self.interactor.signupRequest.phone?.isEmpty ?? true)
            }
            cell.setData(placeHolder: "Phone", value: self.interactor.signupRequest.phone ?? "")
            return cell
        }
        return UITableViewCell()
        
    }
    
    
    @objc func selectedMale(){
        self.isMale = true
        self.isFmale = false
        self.isUnspecified = false
        self.interactor.signupRequest.gender = "Male"
        self.myTable.reloadData()
    }

    @objc func selectedFemale(){
        self.isMale = false
        self.isFmale = true
        self.isUnspecified = false
        self.interactor.signupRequest.gender = "Female"

        self.myTable.reloadData()
    }

    @objc func selectedUnspecified(){
        self.isMale = false
        self.isFmale = false
        self.isUnspecified = true
        self.myTable.reloadData()
        self.interactor.signupRequest.gender = "Unspecified"
    }

    func selectDateOfBirth(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = String.FORMAT_YYYY_MM_DD_HIPHEN
        
        let date = "20000101".createDate(inPattern: .FORMAT_YYYY_MM_DD)
        let maxDate = "20130101".createDate(inPattern: .FORMAT_YYYY_MM_DD)
        
       DatePickerDialog(buttonColor:.getAppThemeColor(), showCancelButton: false).show("Select Date of Birth", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: date, maximumDate: maxDate, datePickerMode: .date) {
            (date) -> Void in
            
            
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = String.FORMAT_YYYY_MM_DD_HIPHEN
                self.interactor.signupRequest.dob = formatter.string(from: dt)
                let dobPath = IndexPath(row: 3, section: 0)
                self.registerTableView.reloadRows(at: [dobPath], with: .automatic)
            }
        }
    }
}
