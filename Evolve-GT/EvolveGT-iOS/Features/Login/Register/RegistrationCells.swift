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
    
    
    @IBOutlet weak var textField: SkyFloatingLabelTextField!
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if didChangeValue != nil{
            didChangeValue!(textfield.text)
        }
    }
    
    
    
    func setData(placeHolder: String, value: String){
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(clearErrorMessage(_:)), for: .allEvents)
        
        textField.placeholder = placeHolder
        textField.text = value
        textField.applyColorTheme()
        
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
