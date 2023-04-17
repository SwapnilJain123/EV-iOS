//
//  EmergencyContactController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 09/02/22.
//  Copyright © 2022 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class EmergencyContactController : ETViewController{
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblFirstName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfLastName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfRelationShip: DropDownList!
    @IBOutlet weak var tfPhone: SkyFloatingLabelTextField!
    
    @IBOutlet weak var maskedRelationShipButton: UIButton!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblRelatioShip: UILabel!
    
    var saveActionHandler :((_ contact: EmergencyContact) ->Void)? = nil
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapRelationShipDropDown(_ sender: Any) {
        tfRelationShip.showList()
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        if validateData(){
            let emergencyContact = EmergencyContact()
            emergencyContact.firstName = lblFirstName.text!
            emergencyContact.lastName = tfLastName.text!
            emergencyContact.phone = tfPhone.text!
            emergencyContact.relationShip = tfRelationShip.text!
            //AppEngine.sharedInstance.emergencyContact = emergencyContact
            saveActionHandler?(emergencyContact)
            dismiss(animated: true, completion: nil)
        }
        
    }
    func validateData() -> Bool{
        var isValid = false
        if lblFirstName.text?.isEmpty ?? true{
            lblFirstName.errorMessage =  ValidationErrors.emptyFirstName
        }else if tfLastName.text?.isEmpty ?? true{
            tfLastName.errorMessage = ValidationErrors.emptyLastName
        }else if tfPhone.text?.isEmpty ?? true{
            tfPhone.errorMessage =  ValidationErrors.invalidPhoneNumber
        }else if tfRelationShip.text?.isEmpty ?? true{
            lblRelatioShip.textColor = .red
        }else{
            isValid = true;
        }
        return isValid
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        btnClose.setBorderColor(color: .darkGray)
        btnSave.applyBoarderColorTheme()
        containerView.showRoundCorner(roundCorner: 5)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        tfRelationShip.applyDropDwonTheme()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userDetails = AppEngine.sharedInstance.userDetails{
            lblFirstName.text = userDetails.evEmergencyFirstName
            tfLastName.text = userDetails.evEmergencyLastName
            tfPhone.text = userDetails.evEmergencyPhone
            tfRelationShip.text = userDetails.evEmergencyRelationship
        }
        tfRelationShip.placeholder = "Relationship"
        
        tfRelationShip.optionArray = AppConstants.emergencyRelationShips
        tfRelationShip.selectedIndex = AppConstants.emergencyRelationShips.firstIndex(where: {$0 == tfRelationShip.text})
        tfRelationShip.didSelect{(selectedText , index ,id) in
            
        }
            
    }
    
}
