//
//  SignViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 14/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftSignatureView
import SkyFloatingLabelTextField

class SignViewController: ETViewController  {
    
    @IBOutlet weak var eventImageHeight: NSLayoutConstraint!
    func populateUI() {
       
        eventTitle.text = eventData.title 
        hostedLabel.text = "Hosted by: \(eventData.hosting ?? "")"
        eventDateLabel.text = "Event date: \(eventData.date ?? "")"
        
        
        if let url = URL(string: eventData.logo?.toValidatedImageUrl().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""){
            let fallbackImage = UIImage(named: "et_fallback_image")
            imageView.kf.setImage(with: url,placeholder: fallbackImage,  options: [.transition(ImageTransition.fade(1))])
        }
        
    }
    
    @IBOutlet weak var tfIssuedState: SkyFloatingLabelTextField!
    
    @IBOutlet weak var signView: SwiftSignatureView!
    
    @IBOutlet weak var hostedLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
   
    @IBOutlet weak var btnClear: UIButton!
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
   

   
    
    @IBAction func clearButtonpressed(_ sender: UIButton) {
        signView.clear()
        saveButton.isEnabled = false
        
    }
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var tfLicenseNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var tfNameAndLocation: SkyFloatingLabelTextField!
    
    
     private func saveSignature() {
           if let signature = signView.signature{
               guard let data = signature.pngData() else {
                   self.ext.showAlert(title:"Signature Error", message: "Signature could not be validated.")
                   return
               }
            var encodedSignature = data.base64EncodedString()
            encodedSignature = "\(AppConstants.ImageTag)\(encodedSignature)"
            
            interactor.saveSignature(userID: AppEngine.sharedInstance.userID, eventID: eventID, nameAndLocation: tfNameAndLocation.text, license: tfLicenseNumber.text, issuingState: fetchStateCode(selectedState: issuedState), signature: encodedSignature, agree: true)
           }
         
       }
    
    let interactor = EWaiverInteractor()
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if tfNameAndLocation.text?.isEmpty ?? true {
            tfNameAndLocation.errorMessage  = ValidationErrors.emptyNameAndLocation
        }else if tfLicenseNumber.text?.isEmpty ?? true {
            tfLicenseNumber.errorMessage  = ValidationErrors.emptyLicense
        }else if tfIssuedState.text?.isEmpty ?? true {
            tfLicenseNumber.errorMessage  = ValidationErrors.emptyLicenseIssuedState
        }else{
            saveSignature()
        }
    }
    var issuedState = ""
    @IBAction func statesButtonPressed(_ sender: UIButton) {
        
        let stateList = createStateArray()
        self.presentSelectionMenu(title: "Select State", data:stateList, dismissHandler: {selectedStates in
            if selectedStates.count > 0{
            self.issuedState = selectedStates[0]
                self.tfIssuedState.text = self.issuedState
            }
            
        })
    }
    
    func fetchStateCode(selectedState:String) -> String{
        var stateCode = ""
        for state in states{
            if state.name == issuedState{
                stateCode = state.code!
            }
        }
        return stateCode
    }
   
    func createStateArray() -> [String]{
        
        var stateList = [String]()
        for state in states{
            stateList.append(state.name ?? "")
        }
        
        return stateList
    }
     
    var eventID = ""
    var userData = UserData()
    var eventData = EventData()
    var states = [State]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        populateUI()
        interactor.delegate = self
        
        rootView.setCardView()
        saveButton.isEnabled = false
        signView.delegate = self
        tfNameAndLocation.applyColorTheme()
        tfLicenseNumber.applyColorTheme()
        tfIssuedState.applyColorTheme()
        saveButton.applyColorTheme()
        eventTitle.textColor = .getAppThemeColor()
        setTextFieldDelegate(textField: tfNameAndLocation)
        setTextFieldDelegate(textField: tfLicenseNumber)
        setTextFieldDelegate(textField: tfIssuedState)
        
        btnClear.showRoundCorner(roundCorner: 5.0)
        
        if(!DeviceType.IS_BIG_SCREEN_DEVICE){
            eventImageHeight.constant = 0
        }
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
        ScreenTitle.TITLE_WAIVER
    }
    
    
    override func showAlert(title: String, message: String) {
        self.ext.showAlert(title: title, message: message, handler: {
            self.navigationController?.popViewController(animated: true)
        })
    }
}

extension SignViewController:SwiftSignatureViewDelegate{
    func swiftSignatureViewDidDrawGesture(_ view: ISignatureView, _ tap: UIGestureRecognizer) {
        
    }
    
    func swiftSignatureViewDidDraw(_ view: ISignatureView) {
        
    }
    
    func swiftSignatureViewDidTapInside(_ view: SwiftSignatureView){
        
    }
    func swiftSignatureViewDidPanInside(_ view: SwiftSignatureView, _ pan:UIPanGestureRecognizer){
       saveButton.isEnabled = true
    }
    
}
extension SignViewController: UITextFieldDelegate{
    
    func setTextFieldDelegate(textField: SkyFloatingLabelTextField){
        textField.addTarget(self, action: #selector(clearErrorMessage(_:)), for: .editingDidBegin)
         textField.addTarget(self, action: #selector(clearErrorMessage(_:)), for: .allEditingEvents)
    }
    @objc func clearErrorMessage(_ textfield: UITextField) {
           if let skyFloatingTF = textfield as? SkyFloatingLabelTextField{
               skyFloatingTF.errorMessage = ""
           }
       }
    
}
