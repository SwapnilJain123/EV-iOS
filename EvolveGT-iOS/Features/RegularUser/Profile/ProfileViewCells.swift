//
//  ProfileViewCells.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 05/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import MBRadioCheckboxButton
import SkyFloatingLabelTextField
import DatePickerDialog


protocol ProfilePicCellDelegate{
    func pickProfileImage()
}
class ProfilePicCell: UITableViewCell{
    static let identifier = "ProfilePicCell"
    
    @IBOutlet weak var imageCover: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    var delegate: ProfilePicCellDelegate? = nil
    func showData(user : UserDetails, selectedImage: UIImage?){
        cameraButton.setBackgroundColor(color: .getAppThemeColor(), forState: .normal)
        imageCover.backgroundColor = .getInactiveGray()
        cameraButton.showRoundCorner()
        
        self.profileImage.roundedImage(borderColor: .getAppThemeColor())
        
        if selectedImage != nil{
            self.profileImage.image = selectedImage
        } else if let imgUrl = user.fullProfileImage?.toValidatedImageUrl(){
            
            let placeHolder = UIImage(named: "avatar")
            self.profileImage.kf.setImage(with: URL(string : imgUrl), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
            
        }
        
    }
    
    @IBAction func didPressCameraButton(_ sender: Any) {
        self.delegate?.pickProfileImage()
    }
}

class ProfileInfoCell: UITableViewCell, RadioButtonDelegate, UITextFieldDelegate {
    func radioButtonDidSelect(_ button: RadioButton) {
        if button == rbMale || button == rbFemale{
            user?.evGender = rbMale.isOn ? "Male" : "Female"
        }else if button == rbLincenceYes || button == rbLicenceNo{
            user?.evRaceLicence = rbLincenceYes.isOn ? "1" : "0"
        }
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {
        
    }
    
    var user: UserDetails?
    
    static let identifier = "ProfileInfoCell"
    
    @IBOutlet weak var tfFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var tfLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var rbFemale: RadioButton!
    @IBOutlet weak var rbMale: RadioButton!
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    
    @IBOutlet weak var calendarIcon: UIImageView!
    @IBOutlet weak var tfPhone: SkyFloatingLabelTextField!
    
    @IBOutlet weak var rbLicenceNo: RadioButton!
    @IBOutlet weak var rbLincenceYes: RadioButton!
    @IBOutlet weak var tfDoB: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnDob: UIButton!
    
    @IBOutlet weak var genderRBContainer: RadioButtonContainerView!
    @IBOutlet weak var trackCheckRBContainer: RadioButtonContainerView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        rbLincenceYes.isEnabled = false
        tfPhone.delegate = self
        rbLicenceNo.isEnabled = rbLincenceYes.isEnabled
    }
    
    func showData(user : UserDetails) {
        self.user = user
        tfFirstName.applyColorTheme()
        tfLastName.applyColorTheme()
        tfEmail.applyColorTheme()
        tfPhone.applyColorTheme()
        tfDoB.applyColorTheme()
        
        rbFemale.applyRadioButtonTheme()
        rbMale.applyRadioButtonTheme()
        rbLicenceNo.applyRadioButtonTheme()
        rbLincenceYes.applyRadioButtonTheme()
        
        rbMale.isOn = user.isMale()
        rbFemale.isOn = !user.isMale()
        
        rbLincenceYes.isOn = user.evRaceLicence == "1"
        rbLicenceNo.isOn = !rbLincenceYes.isOn
        
        rbLincenceYes.isEnabled = user.evRaceLicence?.isEmpty ?? true
        rbLicenceNo.isEnabled = rbLincenceYes.isEnabled
        
        tfFirstName.text = user.firstName?.capitalized
        tfLastName.text = user.lastName?.capitalized
        tfEmail.text = user.email
        tfPhone.text = user.billingPhone
        tfDoB.text = user.evDob?.formattedDate(inputPattern: .FORMAT_YYYY_MM_DD_HIPHEN, outputFormat: .FORMAT_DD_MMM_YYYY)
        
        if !AppEngine.sharedInstance.isEvApp(){
            let icon = UIImage(named: "calendar")
            calendarIcon.image = icon
        }else{
            let icon = UIImage(named: "ic_moto_calendar")
            calendarIcon.image = icon
        }
        
        tfEmail.isUserInteractionEnabled = tfEmail.text?.isEmpty ?? true
        
        trackCheckRBContainer.buttonContainer.delegate = self
        genderRBContainer.buttonContainer.delegate = self
        
        if user.firstName?.isEmpty ?? true{
            tfFirstName.errorMessage = ValidationErrors.emptyFirstName
        }else{
            tfFirstName.errorMessage = ""
        }
        if user.lastName?.isEmpty ?? true{
            tfLastName.errorMessage = ValidationErrors.emptyLastName
        }else{
            tfLastName.errorMessage = ""
        }
        if user.email?.isEmpty ?? true || !user.email!.isValidEmail() {
            tfEmail.errorMessage = ValidationErrors.invalidEmail
        }else{
            tfEmail.errorMessage = ""
        }
//        if user.billingPhone?.isEmpty ?? true{
//            tfPhone.errorMessage = ValidationErrors.invalidPhoneNumber
//        }else{
//            tfPhone.errorMessage = ""
//        }
        if user.evDob?.isEmpty ?? true{
            tfDoB.errorMessage = ValidationErrors.invalidDoB
        }else{
            tfDoB.errorMessage = ""
        }
        
        addTextFiledDelegate(textField: tfFirstName)
        addTextFiledDelegate(textField: tfLastName)
        addTextFiledDelegate(textField: tfEmail)
        addTextFiledDelegate(textField: tfPhone)
        addTextFiledDelegate(textField: tfDoB)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfPhone {
            let maxLength = 11
            
            if string.isEmpty {
                return true
            }
            guard let text = textField.text else { return true }
            let combinedText = "\(text)\(string)"
            
            if combinedText.count > maxLength {
                return false
            }
            
            if let formattedNumber = formatPhoneNumber(phoneNumber: combinedText) {
                self.tfPhone.text = formattedNumber
                self.user?.billingPhone = self.tfPhone.text
            }
        }
        return true
    }
    
    private func addTextFiledDelegate(textField : SkyFloatingLabelTextField){
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(clearErrorMessage(_:)), for: .editingDidBegin)
    }
    
    @IBAction func didPressDoB(_ sender: Any) {
        //delegate?.selectDateOfBirth()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = String.FORMAT_YYYY_MM_DD_HIPHEN
        
        var date = Date()
        if (self.user?.evDob) != nil{
            date = dateFormatter.date(from: self.user!.evDob!) ?? Date()
        }
        
        
        DatePickerDialog(buttonColor:.getAppThemeColor(), showCancelButton: false).show("Select Date of Birth", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: date, datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = String.FORMAT_YYYY_MM_DD_HIPHEN
                let selectedeDate = formatter.string(from: dt)
                self.user?.evDob = selectedeDate
                self.tfDoB.text = self.user!.evDob?.formattedDate(inputPattern: .FORMAT_YYYY_MM_DD_HIPHEN, outputFormat: .FORMAT_DD_MMM_YYYY)
            }
        }
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if textfield == tfFirstName{
            self.user?.firstName = textfield.text
        }else  if textfield == tfLastName{
            self.user?.lastName = textfield.text
        }else if textfield == tfEmail{
            self.user?.email = textfield.text
        }else if textfield == tfPhone{
            self.user?.billingPhone = textfield.text
        }
    }
    @objc func clearErrorMessage(_ textfield: UITextField) {
        if let skyFloatingTF = textfield as? SkyFloatingLabelTextField{
            skyFloatingTF.errorMessage = ""
        }
    }
}

class BikeDataCell: UITableViewCell {
    
    static let identifier = "BikeDataCell"

    @IBOutlet weak var makeTextField: UILabel!
    @IBOutlet weak var modelTextField: UILabel!
    @IBOutlet weak var yearTextField: UILabel!
    @IBOutlet weak var ccTextField: UILabel!
    @IBOutlet weak var transponderTextField: UILabel!
    @IBOutlet weak var deleteButton: UIButton!

    var deleteAction: (() -> Void)?

    @IBAction func deleteTapped(_ sender: UIButton) {
        deleteAction?()
    }
}

class MotorCycleInfoCell: UITableViewCell, UITextFieldDelegate{
    static let identifier = "MotorCycleInfoCell"
    
    var user: UserDetails?
    
    @IBOutlet weak var tfMotorCycle: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfMotorCycleNumber: SkyFloatingLabelTextField!
    
    func showData(user: UserDetails){
        self.user = user
        tfMotorCycle.applyColorTheme()
        tfMotorCycleNumber.applyColorTheme()
        tfMotorCycle.text = user.evMotorcycle
        tfMotorCycleNumber.text = user.evMotorcycleNumber
        
        if user.evMotorcycle?.isEmpty ?? true{
            tfMotorCycle.errorMessage = ValidationErrors.invalidMotorCycleName
        }else{
            tfMotorCycle.errorMessage = ""
        }
        if user.evMotorcycleNumber?.isEmpty ?? true{
            tfMotorCycleNumber.errorMessage = ValidationErrors.invalidMotorCycleNumber
        }else{
            tfMotorCycleNumber.errorMessage = ""
        }
        addTextFiledDelegate(textField: tfMotorCycle)
        addTextFiledDelegate(textField: tfMotorCycleNumber)
    }
    
    private func addTextFiledDelegate(textField : SkyFloatingLabelTextField){
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(clearErrorMessage(_:)), for: .editingDidBegin)
    }
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if textfield == tfMotorCycle{
            self.user?.evMotorcycle = textfield.text
        }else  if textfield == tfMotorCycleNumber{
            self.user?.evMotorcycleNumber = textfield.text
        }
    }
    @objc func clearErrorMessage(_ textfield: UITextField) {
        if let skyFloatingTF = textfield as? SkyFloatingLabelTextField{
            skyFloatingTF.errorMessage = ""
        }
    }
}



class AddressCell : UITableViewCell{
    static let identifier = "AddressCell"
    
    var hasAddress = false
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var addressType: UILabel!
    @IBOutlet weak var btnAddressAction: UIButton!
    private var action :((_ hasAddress: Bool) -> Void)? = nil
    
    func setAction(action: ((_ hasAddress: Bool)->Void)?){
        self.action = action
    }
    
    func showData(type: String, addressContent:String, hasAddress: Bool){
        self.hasAddress = hasAddress
        self.addressType.text = "  \(type)  "
        self.labelAddress.text = addressContent
        
        if hasAddress{
            btnAddressAction.applyEditButtonTheme()
        }else{
            btnAddressAction.applyPlusButtonTheme()
        }
        self.labelAddress.superview?.drawBorder(width: 2.0, borderColor: .lightGray)
    }
    
    @IBAction func didPressActionButton(_ sender: Any) {
        if self.action != nil{
            self.action!(self.hasAddress)
        }
    }
    
}
class SkillInfo: UITableViewCell, RadioButtonDelegate{
    
    var user: UserDetails?
    func radioButtonDidSelect(_ button: RadioButton) {
        user?.everBeenTrack = button.isOn ? 1 : 0
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {
        
    }
    
    static let identifier = "SkillInfo"
    @IBOutlet weak var trackCheckContainer: RadioButtonContainerView!
    
    @IBOutlet weak var rbYes: RadioButton!
    @IBOutlet weak var rbNo: RadioButton!
    @IBOutlet weak var skillLevelDropDown: DropDownList!
    
    func showData(user: UserDetails){
        self.user = user
        rbYes.applyRadioButtonTheme()
        rbNo.applyRadioButtonTheme()
        
        rbYes.isOn = user.hasEverBeenOnTrack
        rbNo.isOn = !rbYes.isOn
        trackCheckContainer.buttonContainer.delegate = self
        skillLevelDropDown.applyDropDwonTheme()
        
        rbYes.isEnabled = String(user.everBeenTrack ?? 0).isEmpty == true
        rbNo.isEnabled = rbYes.isEnabled
        
        skillLevelDropDown.optionArray = AppConstants.SkillLevels
        var skillLevel = AppEngine.sharedInstance.isEvApp() ? user.skillLevel?.uppercased() : user.motoSkill?.capitalized
        
        
        if(AppEngine.sharedInstance.currentUser?.isAdminOrCoach() ?? false){
            skillLevel = AppEngine.sharedInstance.currentUser?.role.capitalized
        }
        
        skillLevelDropDown.text = skillLevel
        
        skillLevelDropDown.didSelect{(selectedText , index ,id) in
            user.skillLevel = selectedText
        }
        skillLevelDropDown.isEnabled = false
    }
    
    
    @IBAction func didPressDropDownList(_ sender: Any) {
      //  skillLevelDropDown.showList()
    }
}
class MotoGladiatorInfoCell: UITableViewCell, UITextFieldDelegate{
    static let identifier = "MotoGladiatorInfoCell"
    
    var user: UserDetails?
    
    @IBOutlet weak var tfRaceNumber: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfAMANumber: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfMotoCCSNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var tfMotoAMAExpiry: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfMotoASRANumber: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfMotoNationality: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfSponsors: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfTeammates: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var calendar: UIImageView!
    @IBAction func didPressAMAExpiryButton(_ sender: Any) {
        let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = String.FORMAT_YYYY_MM_DD_HIPHEN
               
               var date = Date()
               if (self.user?.amaExpires) != nil{
                   date = dateFormatter.date(from: self.user!.amaExpires!) ?? Date()
               }
               
               
        DatePickerDialog(buttonColor:.getAppThemeColor(), showCancelButton: false).show("Select AMA Expiry Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: date, datePickerMode: .date) {
                   (date) -> Void in
                   if let dt = date {
                       let formatter = DateFormatter()
                       formatter.dateFormat = String.FORMAT_YYYY_MM_DD_HIPHEN
                       let selectedeDate = formatter.string(from: dt)
                       self.user?.amaExpires = selectedeDate
                       self.tfMotoAMAExpiry.text = self.user!.amaExpires?.formattedDate(inputPattern: .FORMAT_YYYY_MM_DD_HIPHEN, outputFormat: .FORMAT_DD_MMM_YYYY)
                   }
               }
    }
    
    func showData(user: UserDetails){
        self.user = user
        tfRaceNumber.applyColorTheme()
        tfAMANumber.applyColorTheme()
        tfMotoCCSNumber.applyColorTheme()
        tfMotoAMAExpiry.applyColorTheme()
        tfMotoASRANumber.applyColorTheme()
        tfMotoNationality.applyColorTheme()
        tfSponsors.applyColorTheme()
        tfTeammates.applyColorTheme()
        
        if !AppEngine.sharedInstance.isEvApp(){
            let icon = UIImage(named: "calendar")
            calendar.image = icon
        }else{
            let icon = UIImage(named: "ic_moto_calendar")
            calendar.image = icon
        }
        
        tfRaceNumber.text = user.raceNo
        tfAMANumber.text = user.amaNo
        tfMotoCCSNumber.text = user.ccsNo
        tfMotoAMAExpiry.text = user.amaExpires?.formattedDate(inputPattern: .FORMAT_YYYY_MM_DD_HIPHEN, outputFormat: .FORMAT_DD_MMM_YYYY)
        tfMotoASRANumber.text = user.asraNo
        tfMotoNationality.text = user.nationality
        tfSponsors.text = user.sponsors
        tfTeammates.text = user.teamnames
        
        addTextFiledDelegate(textField: tfRaceNumber)
        addTextFiledDelegate(textField: tfAMANumber)
        addTextFiledDelegate(textField: tfMotoCCSNumber)
        addTextFiledDelegate(textField: tfMotoAMAExpiry)
        addTextFiledDelegate(textField: tfMotoASRANumber)
        addTextFiledDelegate(textField: tfMotoNationality)
        addTextFiledDelegate(textField: tfSponsors)
        addTextFiledDelegate(textField: tfTeammates)
        
        if user.raceNo?.isEmpty ?? true{
            //tfRaceNumber.errorMessage = ValidationErrors.invalidRaceNumber
        }else{
            tfRaceNumber.errorMessage = ""
        }
        if user.amaNo?.isEmpty ?? true{
           // tfAMANumber.errorMessage = ValidationErrors.invalidAMANumber
        }else{
            tfAMANumber.errorMessage = ""
        }
        if user.ccsNo?.isEmpty ?? true{
           // tfMotoCCSNumber.errorMessage = ValidationErrors.invalidCCSNumber
        }else{
            tfMotoCCSNumber.errorMessage = ""
        }
        if user.amaExpires?.isEmpty ?? true{
            //tfMotoAMAExpiry.errorMessage = ValidationErrors.amaExpiryRequired
        }else{
            tfMotoAMAExpiry.errorMessage = ""
        }
        if user.asraNo?.isEmpty ?? true{
           // tfMotoASRANumber.errorMessage = ValidationErrors.invalidASRANumber
        }else{
            tfMotoASRANumber.errorMessage = ""
        }
        if user.nationality?.isEmpty ?? true{
           // tfMotoNationality.errorMessage = ValidationErrors.invalidNationality
        }else{
            tfMotoNationality.errorMessage = ""
        }
        if user.sponsors?.isEmpty ?? true{
           // tfSponsors.errorMessage = ValidationErrors.sponsorRequired
        }else{
            tfSponsors.errorMessage = ""
        }
        if user.teamnames?.isEmpty ?? true{
            //tfTeammates.errorMessage = ValidationErrors.teammateRequired
        }else{
            tfTeammates.errorMessage = ""
        }
        
        
    }
    
    private func addTextFiledDelegate(textField : SkyFloatingLabelTextField){
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(clearErrorMessage(_:)), for: .editingDidBegin)
    }
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if textfield == tfRaceNumber{
            self.user?.raceNo = textfield.text
        }else if textfield == tfAMANumber{
            self.user?.amaNo = textfield.text
        }else if textfield == tfMotoCCSNumber{
            self.user?.ccsNo = textfield.text
        }else if textfield == tfMotoASRANumber{
            self.user?.asraNo = textfield.text
        }else if textfield == tfMotoNationality{
            self.user?.nationality = textfield.text
        } else if textfield == tfSponsors{
            self.user?.sponsors = textfield.text
        } else if textfield == tfTeammates{
            self.user?.teamnames = textfield.text
        }
    }
    @objc func clearErrorMessage(_ textfield: UITextField) {
        if let skyFloatingTF = textfield as? SkyFloatingLabelTextField{
            skyFloatingTF.errorMessage = ""
        }
    }
    
}
class EmergencyContactCell : UITableViewCell, UITextFieldDelegate{
    static let identifier = "EmergencyContactCell"
    
    var user: UserDetails?
    
    @IBOutlet weak var btnRelationShip: UIButton!
    @IBOutlet weak var tfFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var tfLastName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfPhone: SkyFloatingLabelTextField!
    
    @IBOutlet weak var relationshupDropDown: DropDownList!
    
    @IBOutlet weak var labelRelationShip: UILabel!
    func showData(user: UserDetails){
        self.user = user
        tfFirstName.applyColorTheme()
        tfLastName.applyColorTheme()
        tfPhone.applyColorTheme()
        relationshupDropDown.applyDropDwonTheme()
        
        tfFirstName.text = user.evEmergencyFirstName
        tfLastName.text = user.evEmergencyLastName
        tfPhone.text = user.evEmergencyPhone
        
        relationshupDropDown.placeholder = "Relationship"
        
        relationshupDropDown.optionArray = AppConstants.emergencyRelationShips
        relationshupDropDown.text = user.evEmergencyRelationship
        relationshupDropDown.selectedIndex = AppConstants.emergencyRelationShips.firstIndex(where: {$0 == relationshupDropDown.text})
        relationshupDropDown.didSelect{(selectedText , index ,id) in
            user.evEmergencyRelationship = selectedText
            
        }
        
        if user.evEmergencyFirstName?.isEmpty ?? true{
            tfFirstName.errorMessage = ValidationErrors.emptyFirstName
        }else{
            tfFirstName.errorMessage = ""
        }
        if user.evEmergencyLastName?.isEmpty ?? true{
            tfLastName.errorMessage = ValidationErrors.emptyLastName
        }else{
            tfLastName.errorMessage = ""
        }
        if user.evEmergencyPhone?.isEmpty ?? true{
            tfPhone.errorMessage = ValidationErrors.invalidPhoneNumber
        }else{
            tfPhone.errorMessage = ""
        }
        if user.evEmergencyRelationship?.isEmpty ?? true{
            labelRelationShip.textColor = .red
        }else{
            labelRelationShip.textColor = .darkGray
        }
        
        addTextFiledDelegate(textField: tfFirstName)
        addTextFiledDelegate(textField: tfLastName)
        addTextFiledDelegate(textField: tfPhone)
        tfPhone.delegate = self
    }
    private func addTextFiledDelegate(textField : SkyFloatingLabelTextField){
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(clearErrorMessage(_:)), for: .editingDidBegin)
    }
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if textfield == tfFirstName{
            self.user?.evEmergencyFirstName = textfield.text
        }else if textfield == tfLastName{
            self.user?.evEmergencyLastName = textfield.text
        }else if textfield == tfPhone{
            self.user?.evEmergencyPhone = textfield.text
        }
    }
    @objc func clearErrorMessage(_ textfield: UITextField) {
        if let skyFloatingTF = textfield as? SkyFloatingLabelTextField{
            skyFloatingTF.errorMessage = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfPhone {
            let maxLength = 11
            
            if string.isEmpty {
                return true
            }
            guard let text = textField.text else { return true }
            let combinedText = "\(text)\(string)"
            
            if combinedText.count > maxLength {
                return false
            }
            
            if let formattedNumber = formatPhoneNumber(phoneNumber: combinedText) {
                self.tfPhone.text = formattedNumber
            }
        }
        return true
    }
    
    @IBAction func didPressRelationShipButton(_ sender: Any) {
        labelRelationShip.textColor = .darkGray
        relationshupDropDown.showList()
    }
}


import UIKit

class EvolveGTInfoCell: UITableViewCell {

    static let identifier = "EvolveGTInfoCell"

    // Grid fields
    @IBOutlet weak var expertStatusTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var transponderTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var raceNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var nationalityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var amaNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var amaExpiryTextField: SkyFloatingLabelTextField!

    // Sponsor and Team fields
    @IBOutlet weak var sponsorTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var teamNamesTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        teamNamesTextView.layer.borderWidth = 1
        teamNamesTextView.layer.cornerRadius = 4
        teamNamesTextView.layer.borderColor = UIColor.lightGray.cgColor
    }

    func showData(user: UserDetails?) {
        
    }
}
