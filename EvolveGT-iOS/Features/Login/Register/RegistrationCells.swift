//
//  RegistrationCells.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 07/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import MBRadioCheckboxButton

class RegistrationTextFieldCell: UITableViewCell, UITextFieldDelegate{
    
    static let identifier = "TextFieldCell"
    
    var didChangeValue : ((_ text: String?) -> Void)?
    var placeholder: String = "Phone"
    
    @IBOutlet weak var textField: SkyFloatingLabelTextField!
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if didChangeValue != nil{
            didChangeValue!(textfield.text)
        }
    }
    
    func setData(placeHolder: String, value: String){
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(clearErrorMessage(_:)), for: .allEvents)
        textField.delegate = self
        textField.placeholder = placeHolder
        textField.applyColorTheme()
        self.placeholder = placeHolder
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if placeholder == "Phone" {
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
                self.textField.text = formattedNumber
                didChangeValue!(self.textField.text)
            }
        }
        return true
    }

    func showErrorMessage(errorMessage: String, hasError: Bool){
        textField.errorMessage = hasError ? errorMessage : ""
    }
    
    
    @objc func clearErrorMessage(_ textfield: UITextField) {
        if let skyFloatingTF = textfield as? SkyFloatingLabelTextField{
            skyFloatingTF.errorMessage = ""
        }
    }
}
class RegistrationMaskedTextFieldCell: UITableViewCell, UITextFieldDelegate{
    
    static let identifier = "MaskedTextFieldCell"
    
    @IBOutlet weak var textField: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var icon: UIImageView!
    
    var didChangeValue : ((_ text: String?) -> Void)?
    
    var viewAction : (() -> Void)?
    
    
    @IBAction func didTapMaskedView(_ sender: Any) {
        if viewAction != nil{
            viewAction!()
        }
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if didChangeValue != nil{
            didChangeValue!(textfield.text)
        }
    }
    
     func showErrorMessage(errorMessage: String, hasError: Bool){
           textField.errorMessage = hasError ? errorMessage : ""
       }
    
    func setData(placeHolder: String, value: String, evIcon: String, motoIcon: String){
        textField.placeholder = placeHolder
        textField.text = value
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(clearErrorMessage(_:)), for: .allEvents)
        
        if AppEngine.sharedInstance.isEvApp(){
            icon.image = UIImage(named: evIcon)
        }else{
            icon.image = UIImage(named: motoIcon)
        }
        
        textField.applyColorTheme()
    }
    @objc func clearErrorMessage(_ textfield: UITextField) {
        if let skyFloatingTF = textfield as? SkyFloatingLabelTextField{
            skyFloatingTF.errorMessage = ""
        }
    }
}
class TwoOptionsFirestCell: UITableViewCell, RadioButtonDelegate{
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var imgMale: UIImageView!
    @IBOutlet weak var imgFMale: UIImageView!
    @IBOutlet weak var imgUnspecified: UIImageView!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFMale: UIButton!
    @IBOutlet weak var btnUnspecified: UIButton!

    func radioButtonDidSelect(_ button: RadioButton) {
        
        if(didChangeStatus != nil){
            // didChangeStatus!(rbItem1.isOn)
        }
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {
        if(didChangeStatus != nil){
           // didChangeStatus!(rbItem1.isOn)
        }
    }
    
    var didChangeStatus : ((_ checkedStatus: Bool) -> Void)?
    
   // @IBOutlet weak var radioGroup: RadioButtonContainerView!
    
   // @IBOutlet weak var rbItem1: RadioButton!
    
   // @IBOutlet weak var rbItem2: RadioButton!
    
   // var leftItemTitle = "Yes"
   // var rightItemTitle = "No"
    
    func updateUi(title: String, leftItemChecked: Bool){
        
        itemTitle.text = title
       /* rbItem1.applyRadioButtonTheme()
        rbItem2.applyRadioButtonTheme()
        rbItem1.isOn = leftItemChecked
        rbItem2.isOn = !leftItemChecked
        
        rbItem1.setTitle(leftItemTitle, for: .normal)
        rbItem2.setTitle(rightItemTitle, for: .normal)
        
        rbItem1.delegate = self
        rbItem2.delegate = self*/
    }
    
}

class CheckBoxCell:UITableViewCell, CheckboxButtonDelegate{
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        if(actionItemChecked != nil){
            actionItemChecked!(true)
        }
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
        if(actionItemChecked != nil){
            actionItemChecked!(false)
        }
    }
    
    var actionItemChecked : ((_ checked: Bool) -> Void)?
    
    @IBOutlet weak var checkboxItem: CheckboxButton!
    
    func updateUI(status: Bool){
        checkboxItem.applyCheckboxTheme()
        checkboxItem.isOn = status
        checkboxItem.delegate = self
    }
}

class PasswordCell:UITableViewCell, UITextFieldDelegate{
    
    
    @IBOutlet weak var tfPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfConfirmPassword: SkyFloatingLabelTextField!
    
    var didChangePassword : ((_ text: String?) -> Void)?
    var didChangeConfirmPassword : ((_ text: String?) -> Void)?
    let eyeBtnpPassword = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    let eyeBtnpConfirmPassword = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))

    var eyePIconClick: Bool = true
    var eyeCIconClick: Bool = true

    override func awakeFromNib() {
        super.awakeFromNib()
        tfPassword.rightView = eyeBtnpPassword
        tfPassword.rightViewMode = .always
        eyeBtnpPassword.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        eyeBtnpPassword.addTarget(self, action: #selector(eyesButtonTapped), for: .touchUpInside)
        
        tfConfirmPassword.rightView = eyeBtnpConfirmPassword
        tfConfirmPassword.rightViewMode = .always
        eyeBtnpConfirmPassword.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        eyeBtnpConfirmPassword.addTarget(self, action: #selector(eyesBtnTappConfirmP), for: .touchUpInside)
    }

    @objc func eyesButtonTapped(_ sender: UIButton) {
        if eyePIconClick {
            tfPassword.isSecureTextEntry = false
            eyeBtnpPassword.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)

        } else {
            tfPassword.isSecureTextEntry = true
            eyeBtnpPassword.setImage(UIImage(systemName:"eye.fill"), for: .normal)

        }
        eyePIconClick = !eyePIconClick
    }

    @objc func eyesBtnTappConfirmP(_ sender: UIButton) {
        if eyeCIconClick {
            tfConfirmPassword.isSecureTextEntry = false
            eyeBtnpConfirmPassword.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)

        } else {
            tfConfirmPassword.isSecureTextEntry = true
            eyeBtnpConfirmPassword.setImage(UIImage(systemName:"eye.fill"), for: .normal)

        }
        eyeCIconClick = !eyeCIconClick
    }

    func updateUi(password: String, confirmPassword: String){
        tfPassword.text = password
        tfConfirmPassword.text = confirmPassword
        
        tfPassword.applyColorTheme()
        tfConfirmPassword.applyColorTheme()
       
        tfConfirmPassword.addTarget(self, action: #selector(clearErrorMessage(_:)), for: .allEvents)
        tfPassword.addTarget(self, action: #selector(clearErrorMessage(_:)), for: .allEvents)
        
        tfPassword.addTarget(self, action: #selector(passwordChanged(_:)), for: .editingDidEnd)
        tfConfirmPassword.addTarget(self, action: #selector(confirmPasswordChanged(_:)), for: .editingDidEnd)
    }
    
    @objc func passwordChanged(_ textField: UITextField){
        if let action = didChangePassword{
            action(textField.text)
        }
    }
    @objc func confirmPasswordChanged(_ textField: UITextField){
        
        if textField.text != tfPassword.text{
            tfConfirmPassword.errorMessage = ValidationErrors.incorrectConfirmPassword
        }
       if let action = didChangeConfirmPassword{
           action(textField.text)
       }
    }
    @objc func clearErrorMessage(_ textField: UITextField){
          if let skyFloatingTF = textField as? SkyFloatingLabelTextField{
               skyFloatingTF.errorMessage = ""
           }
    }
    
    func showErrorMessage(validPassword: Bool){
           
        if validPassword == false{
            tfPassword.errorMessage = ValidationErrors.emptyPassword
        }else if tfPassword.text != tfConfirmPassword.text{
            tfConfirmPassword.errorMessage = ValidationErrors.incorrectConfirmPassword
        }
    }
}

class TwoOptionsCell: UITableViewCell, RadioButtonDelegate{
    
    @IBOutlet weak var itemTitle: UILabel!
    func radioButtonDidSelect(_ button: RadioButton) {
        
        if(didChangeStatus != nil){
            didChangeStatus!(rbItem1.isOn)
        }
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {
        if(didChangeStatus != nil){
            didChangeStatus!(rbItem1.isOn)
        }
    }
    
    var didChangeStatus : ((_ checkedStatus: Bool) -> Void)?
    
    @IBOutlet weak var radioGroup: RadioButtonContainerView!
    
    @IBOutlet weak var rbItem1: RadioButton!
    
    @IBOutlet weak var rbItem2: RadioButton!
    
    var leftItemTitle = "Yes"
    var rightItemTitle = "No"
    
    func updateUi(title: String, leftItemChecked: Bool){
        
        itemTitle.text = title
        rbItem1.applyRadioButtonTheme()
        rbItem2.applyRadioButtonTheme()
        rbItem1.isOn = leftItemChecked
        rbItem2.isOn = !leftItemChecked
        
        rbItem1.setTitle(leftItemTitle, for: .normal)
        rbItem2.setTitle(rightItemTitle, for: .normal)
        
        rbItem1.delegate = self
        rbItem2.delegate = self
    }
}

func formatPhoneNumber(phoneNumber: String) -> String? {
  // Remove non-numeric characters
  let numbersOnly = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

  // Check if the phone number has the correct length (10 digits)
  guard numbersOnly.count == 10 else {
    return nil  // Return nil if the number is not 10 digits long
  }

  // Format the phone number
  let firstPart = String(numbersOnly.prefix(3))
  let secondPart = String(numbersOnly.dropFirst(3).prefix(3))
  let lastPart = String(numbersOnly.suffix(4))

  return "(\(firstPart)) \(secondPart)-\(lastPart)"
}
