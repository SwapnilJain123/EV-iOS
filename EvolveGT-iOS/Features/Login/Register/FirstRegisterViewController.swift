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
import AEOTPTextField

class FirstRegisterViewController:ETViewController, AEOTPTextFieldDelegate {
        
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var OTPVerificationField: AEOTPTextField!
    @IBOutlet weak var OTPVerificationView: UIView!
    @IBOutlet weak var indicator: RegPhaseIndicator!
    @IBOutlet weak var registerTableView: UITableView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    
    let interactor = RegisterInteractor()
    var validated : Bool = false;
    var isMale: Bool = false
    var isFmale: Bool = false
    var isUnspecified: Bool = true
    var isEmailVerified: Bool = false
    var verifiedEmailID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ext.showNavbar()
        ext.showBackButton()
        registerTableView.delegate = self
        registerTableView.dataSource = self
        
        interactor.delegate = self

        btnNext.applyColorTheme()
        btnSubmit.applyColorTheme()
        
        indicator.setStep1()
        
        OTPVerificationView.frame = self.view.bounds
        self.view.addSubview(OTPVerificationView)
        OTPVerificationView.isHidden = true
        
        OTPVerificationField.otpDelegate = self
        OTPVerificationField.configure(with: 6)
        
        interactor.handleSendOTP = { isSuccess in
            if isSuccess {
                self.OTPVerificationView.isHidden = false
            }
        }
        
        interactor.handleVerifyOTP = { isSuccess in
            if isSuccess {
                self.isEmailVerified = true
                self.navigateToSecondScreen()
            }
        }
    }
    
    func didUserFinishEnter(the code: String) {
        self.interactor.verifyOtpRequest.otp = code
    }

    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_CREATE_ACCOUNT
    }
    
    //MARK: - Actions
    @IBAction func didPressNextButton(_ sender: UIButton) {
        if verifiedEmailID != "", (verifiedEmailID == self.interactor.signupRequest.email ?? "") && isEmailVerified {
            navigateToSecondScreen()
        } else {
            // Check verify Email
            interactor.checkEmailVerification { result in
                switch result {
                case .success(let themeData):
                    print(themeData.eEmailVerification ?? "")
                    self.checkAndShowOTPVerificationView(isEmailVerfiy: themeData.eEmailVerification ?? "0")
                case .failure(let error):
                    print("Failed to fetch theme: \(error.localizedDescription)")
                }
            }
            // interactor.otpSendForEmailVerification()
        }
    }
    
    @IBAction func didPressCloseViewButton(_ sender: UIButton) {
        self.OTPVerificationField.clearOTP()
        OTPVerificationView.isHidden = true
    }

    @IBAction func didPressSubmitButton(_ sender: UIButton) {
        OTPVerificationField.resignFirstResponder()
        interactor.otpVerification()
    }
    
    @IBAction func haveAnAccountButtonPressed(_ sender: UIButton) {
        self.ext.pushViewController(storyBoard: "Main", VCIdentifier: "LoginVC")
    }

    @IBAction func resendOTPPressed(_ sender: UIButton) {
        self.OTPVerificationField.clearOTP()
        interactor.otpSendForEmailVerification()
    }

    func navigateToSecondScreen() {
        if self.interactor.validatePersonalData(){
            self.OTPVerificationView.isHidden = true
            self.verifiedEmailID = self.interactor.signupRequest.email ?? ""
            self.OTPVerificationField.clearOTP()
            let vc =  self.ext.getViewController(storyBoard: "Register", VCIdentifier: "secondRegisterVC")as! SecondRegisterViewController
            vc.interactor = self.interactor
            self.ext.pushViewController(viewController: vc)
        }
    }
    
    func checkAndShowOTPVerificationView(isEmailVerfiy:String){
        if isEmailVerfiy == "1" {
            interactor.otpSendForEmailVerification()
        } else {
            self.navigateToSecondScreen()
        }
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
                self.interactor.otpSendRequest.email = text
                self.interactor.verifyOtpRequest.email = text
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
        reloadRadioButtonCell()
    }

    @objc func selectedFemale(){
        self.isMale = false
        self.isFmale = true
        self.isUnspecified = false
        self.interactor.signupRequest.gender = "Female"
        reloadRadioButtonCell()
    }

    @objc func selectedUnspecified(){
        self.isMale = false
        self.isFmale = false
        self.isUnspecified = true
        self.interactor.signupRequest.gender = "Unspecified"
        reloadRadioButtonCell()
    }

    func reloadRadioButtonCell() {
        let indexPath = IndexPath(row: 4, section: 0)
        self.myTable.reloadRows(at: [indexPath], with: .fade)
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
