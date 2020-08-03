//
//  SignaturePreviewViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 29/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
class SignaturePreviewViewController : ETViewController{
    
    
    @IBOutlet weak var closeButton: UIButton!
    let interactor = SignatureIntercator()
    var signatureId = ""
    @IBOutlet weak var signatureImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ext.showBackButton()
        self.ext.setScreenTitle(title: ScreenTitle.TITLE_SIGNATURE)
        signatureImage.accessibilityIdentifier = "SignatureImage"
        closeButton.drawBorder(width: 2.0, borderColor: .clear)
        getSignature()
        
    }
    func getSignature(){
        interactor.signatureViewDelegate = self
        interactor.getSignature(signatureId: signatureId)
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SignaturePreviewViewController: SignatureViewDelegate{
    
    func didUpdateSignature() {
        //Ignored
    }
    
    func didFetchSignature(signature: Data) {
        let image = UIImage(data: signature)
        signatureImage.layer.borderColor = UIColor.gray.cgColor
        signatureImage.layer.borderWidth = 1.0
        signatureImage.image = image
        closeButton.isHidden = false
    }
    
    
}
