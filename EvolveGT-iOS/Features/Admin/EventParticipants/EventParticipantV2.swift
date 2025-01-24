//
//  EventParticipantV2.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 01/02/22.
//  Copyright © 2022 YaraTech. All rights reserved.
//

import Foundation
import UIKit

protocol EventParticipantV2Delegate  {
    func clickedOnSignature(_ cell: EventParticipantCellV2, participant: EventParticipant?)
    func clickedOnUpgradeSkill(_ cell: EventParticipantCellV2, participant: EventParticipant?)
    func clickedOnAccessories(_ cell: EventParticipantCellV2, participant: EventParticipant?)
    func clickedOnMotoIcon(_ cell: EventParticipantCellV2, participant: EventParticipant?)
}
class EventParticipantCellV2: UITableViewCell{
    
    var delegate : EventParticipantV2Delegate?

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var skill: UILabel!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var dateOfBirth: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var btnDeleteEvent: UIButton!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backroundView: UIView!
    

    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var flaggedIconebtn: UIButton!
    @IBOutlet weak var detailLable: UILabel!
    var btnSkillUpgrade: UIButton? = nil
    var tdPurchaseWarning: UIButton? = nil
    var btnMotoIcon: UIButton? = nil
    
    @IBOutlet weak var attributesView: UIView!
    @IBOutlet weak var aceessoriesStackView: UIStackView!
    
    @IBOutlet weak var accessoriesView: UIView!
    
    
    @IBOutlet weak var tvEmail: UILabel!
    @IBOutlet weak var tvDuties: UILabel!
    @IBOutlet weak var tvDayJob: UILabel?
    
    @IBOutlet weak var accessoriesWidth: NSLayoutConstraint!
    var stackWidth: CGFloat = 0
    
    var eventParticipant: EventParticipant? {
        didSet {
            updateUI()
        }
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateUI() {
        
        stackWidth = 0
        
        userName.text = eventParticipant?.namewithRole ?? "-"
        skill.text = eventParticipant?.skillLevel
        tvEmail.text = eventParticipant?.email ?? "-"
        tvDuties.text = eventParticipant?.consolidatedDuties
        //tvDayJob.text = eventParticipant?.jobAssigned ?? "NA"
        detailLable.text = eventParticipant?.adminNotes ?? "NA"
        flaggedIconebtn.isHidden = eventParticipant?.personAsAProblem == 1 ? false : true

        userID.text! = "#"
        if let userIDString = eventParticipant?.userID {
            userID.text?.append("\(userIDString)")
        }
        dateOfBirth.text = eventParticipant?.evDob?.formattedDate(inputPattern: .FORMAT_YYYY_MM_DD_HIPHEN, outputFormat: .FORMAT_DD_MMM_YYYY) ?? "-"
        orderId.text = "#"
        if let userIDString = eventParticipant?.orderID {
            orderId.text?.append("\(userIDString)")
        }
        
        aceessoriesStackView.removeAllArrangedSubviews()
        
        
        if AppEngine.sharedInstance.isEvApp(){
            if (eventParticipant?.motoPurchased ?? false) && !(eventParticipant?.tdPurchased ?? false){
                addIconButton(evIcon: "ic_td_not_purchased", motoIcon: "ic_td_not_purchased_blue", action: #selector(purchaseWarningButtonTapped))
            }
            if eventParticipant?.motoPurchased ?? false{
                addIconButton(evIcon: "ic_moto_green", motoIcon: "ic_moto_blue", action: #selector(motoButtonTapped))
            }
        }
        if (eventParticipant?.hasAccessories ?? false){
            addIconButton(evIcon: "admin_moto_star", motoIcon: "admin_moto_star", action: #selector(trainingButtonTapped))
        }
        if eventParticipant?.isSignEnabled ?? false{
            addSignButton()
        }
        accessoriesWidth.constant = stackWidth
        
        backroundView.backgroundColor = UIColor.init(hexFromString: "e6e6e6")
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 0.8)
        containerView.setCardView()
        
        userName.textColor = UIColor.getAppThemeColor()
         userID.textColor = UIColor.getAppThemeColor()
         skill.textColor = UIColor.getAppThemeColor()
         dateOfBirth.textColor = UIColor.getAppThemeColor()
         orderId.textColor = UIColor.getAppThemeColor()
        tvEmail.textColor = UIColor.getAppThemeColor()
        tvDuties.textColor = UIColor.getAppThemeColor()
       // tvDayJob.textColor = UIColor.getAppThemeColor()
        detailLable.textColor = UIColor.getAppThemeColor()
        checkIfTextIsTruncated()
    }
    
    @IBAction func didTapUpgradeSkill(_ sender: Any) {
        delegate?.clickedOnUpgradeSkill(self, participant: eventParticipant)
    }
    @objc func purchaseWarningButtonTapped(sender: UIButton!) {
           
    }
    @objc func motoButtonTapped(sender: UIButton!) {
        delegate?.clickedOnMotoIcon(self, participant: eventParticipant)
    }
    @objc func trainingButtonTapped(sender: UIButton!) {
        delegate?.clickedOnAccessories(self, participant: eventParticipant)
    }
    @objc func signButtonTapped(sender: UIButton!) {
        delegate?.clickedOnSignature(self, participant: eventParticipant)
    }
    
    
    func addIconButton(evIcon: String, motoIcon:String, action: Selector){
        let signButton = UIButton()
        aceessoriesStackView.addArrangedSubview(signButton)
        signButton.snp.makeConstraints({ make in
            make.height.equalTo(40)
            make.width.equalTo(40)
            stackWidth += 42
        })
        var image = UIImage(named: evIcon) as UIImage?
        if !AppEngine.sharedInstance.isEvApp(){
            image = UIImage(named: motoIcon) as UIImage?
        }
        signButton.setImage(image, for: .normal)
        signButton.addTarget(self, action: action, for: .touchUpInside)
    }
    func addSignButton(){
        let signButton = UIButton()
        aceessoriesStackView.addArrangedSubview(signButton)
        signButton.snp.makeConstraints({ make in
            make.height.equalTo(40)
            make.width.equalTo(40)
            stackWidth += 42
        })
            var image = UIImage(named: "sign_green") as UIImage?
            if eventParticipant?.signature ?? false{
                if AppEngine.sharedInstance.isEvApp(){
                    image = UIImage(named: "admin_moto_signature") as UIImage?
                }
            }else{
                image = UIImage(named: "sign") as UIImage?
                
            }
        signButton.addTarget(self, action: #selector(signButtonTapped), for: .touchUpInside)
        signButton.setImage(image, for: .normal)
    }
    
    func checkIfTextIsTruncated() {
        guard let text = detailLable.text else { return }
        
        let maxSize = CGSize(width: detailLable.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let textAttributes: [NSAttributedString.Key: Any] = [.font: detailLable.font!]
        
        let requiredSize = (text as NSString).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        
        // Show "More" button if required height exceeds label's frame height
        if requiredSize.height > detailLable.frame.height {
            moreButton.isHidden = false
        } else {
            moreButton.isHidden = true
        }
    }

}
