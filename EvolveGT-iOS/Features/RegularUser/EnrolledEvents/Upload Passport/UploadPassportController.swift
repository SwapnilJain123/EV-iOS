//
//  UploadPassportController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 26/01/22.
//  Copyright © 2022 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import SwiftSignatureView
import MBRadioCheckboxButton

class UploadPassportController : ETViewController{
    
    static let identifier = "UploadPassportController"
    
    @IBOutlet weak var tvTitle: UILabel!
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var cbAgree: CheckboxButton!
    
    @IBOutlet weak var btnUploadSelfie: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var signaturePad: SwiftSignatureView!
    
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    
    var selectedImage :UIImage? = nil
    let interactor = UploadPassportInteractor()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ext.showNavbar()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCanvas()
        btnUploadSelfie.applyColorTheme()
        
        self.ext.showBackButton()
        cbAgree.delegate = self
        btnSave.isEnabled = false
        btnSave.applyColorTheme()
        
       
        btnClear.drawBorder(width: 2.0, borderColor: .clear)
        btnClose.drawBorder(width: 2.0, borderColor: .clear)
        
        
        cbAgree.applyCheckboxTheme()
        
        btnSave.accessibilityIdentifier = "SaveSignature"
        btnSave.accessibilityIdentifier = "SignatureCanvas"
        signaturePad.layer.borderColor = UIColor.getAppThemeColor().cgColor
        
        signaturePad.delegate = self
        
        interactor.delegate = self
        interactor.passportUploaded = {
            self.ext.showAlert(title: "", message: "Passport saved successfully", handler: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    override func getScreenTitle() -> String? {
        "Upload Passport"
    }
    private func setUpCanvas() {
        signaturePad.layer.borderColor = UIColor.black.cgColor
        signaturePad.layer.borderWidth = 2.0
        signaturePad.layer.cornerRadius = 5.0
    }
    
    @IBAction func didTapUploadBtn(_ sender: Any) {
        pickProfileImage()
    }
    
    @IBAction func didTapSaveBtn(_ sender: Any) {
        
        if selectedImage == nil{
            showAlert(title: "", message: "Please select image.")
        }else{
            if let signatureData = signaturePad.signature?.pngData(){
                if let image = selectedImage?.jpegData(compressionQuality: 0.1){
                    interactor.savePassport(selfie: image, signature: signatureData)
                }

            }else{
                showErrorToastMessage(message: "Signature could not be read. Please redraw and try again.")
            }
        }
    }
    
    @IBAction func didTapClear(_ sender: Any) {
        signaturePad.clear()
        btnSave.isEnabled = false
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
}

extension UploadPassportController: CheckboxButtonDelegate {
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        btnSave.isEnabled = signaturePad.signature != nil
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
        btnSave.isEnabled = false
    }
    
}

extension UploadPassportController: SwiftSignatureViewDelegate{
    func swiftSignatureViewDidDrawGesture(_ view: ISignatureView, _ tap: UIGestureRecognizer) {
        
    }
    
    func swiftSignatureViewDidDraw(_ view: ISignatureView) {
        
    }
    
   
    
    func swiftSignatureViewDidTapInside(_ view: SwiftSignatureView){
        
    }
    func swiftSignatureViewDidPanInside(_ view: SwiftSignatureView, _ pan:UIPanGestureRecognizer){
        btnSave.isEnabled = cbAgree.isOn && view.signature != nil
    }
    
    
}
extension  UploadPassportController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
       
        self.selectedImage = image.fixOrientation()
        picker.dismiss(animated: true, completion: {
            print("Image Selected.")
        })
        
    }
    
    func openCamera(){
        if(UIImagePickerController.isSourceTypeAvailable(.camera))
        {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            DispatchQueue.main.async {
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }else{
            self.showErrorToastMessage(message: "Not supported in this device.")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillDisappear(animated)
        self.ext.hideNavbar()
    }
    func pickProfileImage() {
        
        
        openCamera()
        /*
        let options = [ "Camera", "Photo Library"]
        self.ext.presentOptions(title: "Choose Image", message: "", options: options, selected: nil, preferredStyle: .actionSheet){selected in
            
            if selected == "Camera"{
               openCamera()
            }else if selected == "Photo Library"{
                if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary))
                {
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = .photoLibrary
                    imagePickerController.delegate = self
                    DispatchQueue.main.async {
                        self.present(imagePickerController, animated: true, completion: nil)
                    }
                }else{
                    self.showErrorToastMessage(message: "Not supported in this device.")
                }
            }
        }*/
        
    }
    
}
