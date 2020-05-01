//
//  SignatureInputViewController.swift
//  EvolveGT
//
//  Created by Subair Ariyil S on 10/07/19.
//  Copyright © 2019 com.dev.evolve. All rights reserved.
//

import UIKit
import SwiftSignatureView

protocol SignatureRefreshDelegate {
    func didModifySignature(signatureId: String)
}
class SignatureReaderController: ETViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var canvasView: SwiftSignatureView!
    @IBOutlet weak var termsCheckBox: EVCheckBox!
    var eventparticipant: EventParticipant?
   
    let interactor = SignatureIntercator()
    var delegate : SignatureRefreshDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCanvas()
        self.ext.showBackButton()
        self.ext.setScreenTitle(title: ScreenTitle.TITLE_SIGNATURE)
        termsCheckBox.delegate = self
        saveButton.isEnabled = false
        saveButton.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
        interactor.delegate = self
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
    @IBAction func termsCheckBoxAction(_ sender: UIButton) {
        
    }
}

extension SignatureReaderController: EVCheckBoxDelegate {
    func tappedOnBox(checkBox: EVCheckBox, selected: Bool) {
        saveButton.isEnabled = selected
        saveButton.backgroundColor = saveButton.isEnabled ? #colorLiteral(red: 0.03021821566, green: 0.6054252386, blue: 0.2137703896, alpha: 1) : #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
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
