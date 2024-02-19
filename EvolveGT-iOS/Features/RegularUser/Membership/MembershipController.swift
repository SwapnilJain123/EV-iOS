//
//  MembershipController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
class MembershipController : ETViewController{
    
    @IBOutlet weak var membershipListView: UICollectionView!
    let interactor = MembershipInteractor()
    var membershipList = [Membership]()
    
    var mrlMessage = AppConstants.MRLMessage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.delegate = self
        interactor.membershipDelegate = self
        interactor.mrlMessageDelegate = self
        
        membershipListView.dataSource = self
        membershipListView.delegate = self
        
        interactor.fetchAvailableMemberships()
        interactor.getMRLMembershipMessage()
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
        ScreenTitle.TITLE_MEMBERSHIP
    }
}
extension MembershipController : MembershipCellDelegate{
    func showMembershipDetails(membership: Membership) {
         
        let VC = self.ext.getViewController(storyBoard: "Membership", VCIdentifier: "membershipDetailsVC") as! MembershipDetailsViewController
        
        VC.slug = membership.slug
        VC.membershipTitle = membership.title
        
        self.ext.pushViewController(viewController: VC)
        
    }
    
    func addMembershipToCart(membership: Membership) {
        
        if membership.membershipID == Membership.ID_MRL{
            
            let user = AppEngine.sharedInstance.userDetails
            if user?.canBuyMRLMembership ?? false == false{
                self.ext.confirmationAlert(title: "User Race License", message: self.mrlMessage, btnText: "I Agree", btnDismiss: "Cancel", handler: {
                    self.interactor.addMembershipToCart(membership: membership)
                })
            }else{
                self.interactor.addMembershipToCart(membership: membership)
            }
        }else{
            interactor.addMembershipToCart(membership: membership)
        }
    }
    
    
}
extension MembershipController : MembershipListDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        membershipList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MembershipCell.identifier, for: indexPath) as! MembershipCell
        cell.showData(membership: membershipList[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.size.width/2) - 5
        return CGSize(width: width, height: 235.0)
        
    }
    
    func didFetchMembershipList(memberships: [Membership]) {
        membershipList.removeAll()
        membershipList.append(contentsOf: memberships)
        membershipListView.reloadData()
    }
    
}

extension MembershipController: MRLMessageDelegate{
    func didFetchMRLMessage(message: String) {
        self.mrlMessage = message
    }
    
    
}
protocol MembershipCellDelegate{
    func  showMembershipDetails(membership : Membership)
    func addMembershipToCart(membership : Membership)
}
class MembershipCell : UICollectionViewCell{
    static let identifier = "MembershipCell"
    
    var membership = Membership()
    var delegate :MembershipCellDelegate?
    
    @IBOutlet weak var rootView: UIView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var btnPurchase: UIButton!
    
    @IBOutlet weak var btnViewMOre: UIButton!
    @IBOutlet weak var LabelRole: UILabel!
    
    @IBOutlet weak var labelPrice: UILabel!
    
    @IBOutlet weak var season: UILabel!
    
    
    @IBAction func didPressPurchaseButton(_ sender: UIButton) {
        if !self.membership.isOutOfStock{
            delegate?.addMembershipToCart(membership: membership)
        }
    }
    
    @IBAction func didPressViewMoreButton(_ sender: UIButton) {
        delegate?.showMembershipDetails(membership: membership)
        
    }
    
    func showData(membership: Membership){
        self.membership = membership
        
        rootView.setCardView()
        btnPurchase.isHidden = !(membership.canPurchase(currentMembership: AppEngine.sharedInstance.membership))
       
        btnPurchase.isEnabled = !membership.isOutOfStock
        btnPurchase.setTitle(membership.isOutOfStock ? "Sold Out" : "Purchase", for: .normal)
        
        labelPrice.text = membership.price?.formatToAmount()
        LabelRole.text = membership.title?.capitalized
        season.text = membership.season
        
        if membership.isCurrentMembership{
            topView.backgroundColor = .getAppThemeColor()
            labelPrice.textColor = .white
            LabelRole.textColor = .white
            season.textColor = .white
        }else{
            topView.backgroundColor = .white
            labelPrice.textColor = .black
            LabelRole.textColor = .black
            season.textColor = .black
        }
        
        btnViewMOre.applyBoarderColorTheme()
        btnPurchase.applyColorTheme()
    }
    
}
