//
//  MembershipDetailsViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 10/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit
import Kingfisher

class MembershipDetailsViewController: ETViewController,MembershipDetailsDelegate, MRLMessageDelegate {
    var membershipDetails = MembershipDetails()
    
    @IBOutlet weak var outOfStockLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var membershipImage: UIImageView!
    var mrlMessage = AppConstants.MRLMessage
   
    @IBAction func addToCartButton(_ sender: UIButton) {
        
        if membershipDetails.membershipID == Membership.ID_MRL{
            
            let user = AppEngine.sharedInstance.userDetails
            if user?.canBuyMRLMembership ?? false == false{
                self.ext.confirmationAlert(title: "User Race License", message: self.mrlMessage, btnText: "I Agree", btnDismiss: "Cancel", handler: {
                    self.membershipInteractor.addMembershipToCart(membership: self.membershipDetails)
                })
            }else{
                 membershipInteractor.addMembershipToCart(membership: membershipDetails)
            }
        }else{
            membershipInteractor.addMembershipToCart(membership: membershipDetails)
        }
    }
    
    @IBOutlet weak var membershipDetailsWebView: UIWebView!
    @IBOutlet weak var addToCartButton: UIButton!
    
    func didFetchMembershipDetails(membershipDetails: MembershipDetails) {
        self.membershipDetails = membershipDetails
        titleLabel.text! = membershipDetails.title!
        if  let url = URL(string :membershipDetails.image?.toValidatedImageUrl() ?? ""){
            let fallbackImage = UIImage(named: "et_fallback_image")
            membershipImage.kf.setImage(with: url,
                                        placeholder: fallbackImage,
                                        options: [.transition(ImageTransition.fade(1))])
            
        }
        
        membershipDetailsWebView.loadHTMLString(membershipDetails.description ?? "", baseURL: nil)
        
        addToCartButton.isHidden = !membershipDetails.canPurchase(currentMembership: AppEngine.sharedInstance.membership)
        
        if membershipDetails.stockStatus?.isOutOfStock() ?? true{
            outOfStockLabel.text! = "Out Of stock!"
            outOfStockLabel.textColor = UIColor.red
            addToCartButton.isEnabled = false
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        addToCartButton.applyColorTheme()
        
    }
    
    var membershipInteractor = MembershipInteractor()
    
    var slug:String?
    var membershipTitle:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        membershipInteractor.delegate = self
        membershipInteractor.membershipDetailsDelegate = self
        membershipInteractor.mrlMessageDelegate = self
        
        membershipInteractor.getMembershipDetails(slug: slug!)
        membershipInteractor.getMRLMembershipMessage()
        
        addToCartButton.isHidden = true
        
        
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
        membershipTitle
    }
    
    func didFetchMRLMessage(message: String) {
        mrlMessage = message
    }
}
