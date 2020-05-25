//
//  SignatureInputViewController.swift
//  EvolveGT
//
//  Created by Subair Ariyil S on 10/07/19.
//  Copyright © 2019 com.dev.evolve. All rights reserved.
//

import UIKit
import SwiftSignatureView
import MBRadioCheckboxButton

protocol SignatureRefreshDelegate {
    func didModifySignature(signatureId: String)
}
class SignatureReaderController: ETViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var canvasView: SwiftSignatureView!
   
    var eventparticipant: EventParticipant?
   
    
    @IBOutlet weak var termsCheckBox: CheckboxButton!
    let interactor = SignatureIntercator()
    var delegate : SignatureRefreshDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCanvas()
        self.ext.showBackButton()
        self.ext.setScreenTitle(title: ScreenTitle.TITLE_SIGNATURE)
        termsCheckBox.delegate = self
        saveButton.isEnabled = false
        saveButton.applyColorTheme()
        termsCheckBox.applyCheckboxTheme()
        interactor.delegate = self
        
        canvasView.layer.borderColor = UIColor.getAppThemeColor().cgColor
    }
    
    private func setUpCanvas() {
        canvasView.layer.borderColor = UIColor.black.cgColor
        canvasView.layer.borderWidth = 2.0
        canvasView.layer.cornerRadius = 5.0
    }

    private func saveSignature() {
        if let signature = canvasView.signature{
            guard let data = signature.pngData() else {
                self.ext.showAlert(title:"Signature Error", message: "Signature could not be validated.")
                return
            }
            interactor.saveSignature(signatureId: eventparticipant?.signatureID ?? "", signature: data)
        }
      
    }
    
    @IBAction func clearInputAction(_ sender: UIButton) {
        canvasView.clear()
    }
    
    @IBAction func saveInputAction(_ sender: UIButton) {
        saveSignature()
    }
    
    @IBAction func close(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)
    }

}

extension SignatureReaderController: CheckboxButtonDelegate {
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
          saveButton.isEnabled = true
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
        saveButton.isEnabled = false
    }
    
}

extension SignatureReaderController: SignatureViewDelegate{
    func didUpdateSignature() {
        self.ext.showAlert(title: "Signature Saved", message: SuccessMessages.signatureSaved){
            self.delegate?.didModifySignature(signatureId: self.eventparticipant!.signatureID)
            self.navigationController?.popViewController(animated: true)
        }
    }
    func didFetchSignature(signature: Data) {
        //Ignored
    }
    
}
