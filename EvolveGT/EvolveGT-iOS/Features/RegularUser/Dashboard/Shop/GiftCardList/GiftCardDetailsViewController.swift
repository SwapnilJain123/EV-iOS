//
//  GiftCardDetailsViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 03/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Kingfisher

class GiftCardDetailsViewController: ETViewController,GiftCardDetailsDelegate {
    @IBOutlet weak var giftTitle: UILabel!
    @IBOutlet weak var giftPriceLabel: UILabel!
    @IBOutlet weak var giftCardImage: UIImageView!
    @IBOutlet weak var receiverEmailTF: SkyFloatingLabelTextField!
    @IBOutlet weak var errorViewLabel: UILabel!
    @IBOutlet weak var receiverNameTF: SkyFloatingLabelTextField!
    
    var giftCardDetails:GiftCardDetails?
    
    let giftCardInteractor = GiftCardInteractor()
    
    func didFetchGiftCardDetails(giftCardDetails: GiftCardDetails) {
        
        self.giftCardDetails = giftCardDetails
        giftTitle.text = giftCardDetails.title
        giftPriceLabel.text = giftCardDetails.price?.formatToAmount(prefix: "Price: ")
        
        if  let url = URL(string :giftCardDetails.image?.toValidatedImageUrl() ?? ""){
            let fallbackImage = UIImage(named: "et_fallback_image")
            giftCardImage.kf.setImage(with: url,
                                      placeholder: fallbackImage,
                                      options: [.transition(ImageTransition.fade(1))])
            
        }
        
    }
    @IBOutlet weak var addToCartButton: UIButton!
    @IBAction func addToCartButtonPressed(_ sender: UIButton) {
        
        
        if !AppEngine.sharedInstance.isUserLoggedIn(){
            self.ext.confirmationAlert(title: AlertTitle.loginRequired, message: MessageConstants.loginRequired, btnText: "Login"){
                self.dashboardManager.switchToLoginPage()
                return
            }
        }else{
            errorViewLabel.text! = ""
            if receiverNameTF.text!.isEmpty {
                errorViewLabel.text! = ErrorMessages.emptyReceiverName
                
            }else if receiverEmailTF.text!.isEmpty {
                errorViewLabel.text! = ErrorMessages.emptyReceiverEmail
            }else if receiverEmailTF.text!.isValidEmail() == false{
                errorViewLabel.text! = ErrorMessages.invalidEmail
            }else{
                giftCardInteractor.addGiftCardToCart(name: receiverNameTF.text!, email: receiverEmailTF.text!, giftCardDetails:giftCardDetails! )
                
            }
            
        }
    }
    
    
    var slug = ""
    var screenTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        giftCardInteractor.viewDelegate = self
        giftCardInteractor.giftCardDetailsDelegate = self
        
        giftCardInteractor.getGiftCardDetails(slug: slug)
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        receiverNameTF.applyColorTheme()
        receiverEmailTF.applyColorTheme()
        giftPriceLabel.textColor = .getAppThemeColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addToCartButton.applyColorTheme()
    }
    override func getScreenTitle() -> String? {
        
        return screenTitle
        
    }
    
    
}
