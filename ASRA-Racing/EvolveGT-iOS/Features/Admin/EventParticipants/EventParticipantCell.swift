//
//  EventParticipantCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 23/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

protocol EventParticipantCellDelegate  {
    func clickedOnSignature(_ cell: EventParticipantCell, participant: EventParticipant?)
    func clickedOnUpgradeSkill(_ cell: EventParticipantCell, participant: EventParticipant?)
    func clickedOnAccessories(_ cell: EventParticipantCell, participant: EventParticipant?)
    func clickedOnMotoIcon(_ cell: EventParticipantCell, participant: EventParticipant?)
}

class EventParticipantCell: UITableViewCell{
    
    
    var eventParticipant: EventParticipant? {
        didSet {
            updateUI()
        }
    }
    
    var delegate : EventParticipantCellDelegate?
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var skill: UILabel!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var dateOfBirth: UILabel!
    @IBOutlet weak var orderId: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backroundView: UIView!
    
    @IBOutlet weak var btnTraining: UIButton!
    @IBOutlet weak var btnSign: UIButton?
    @IBOutlet weak var btnSkillUpgrade: UIButton!
    

    
    @IBOutlet weak var tdPurchaseWarning: UIButton!
    
    @IBOutlet weak var btnMotoIcon: UIButton!
    override func prepareForReuse() {
        
        super.prepareForReuse()
        btnSign?.isHidden = false
        btnTraining?.isHidden = false

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateUI() {
        userName.text = eventParticipant?.namewithRole ?? "-"
        skill.text = eventParticipant?.skillLevel
        userID.text! = "#"
        userID.text?.append(eventParticipant?.userID ?? "-")
        dateOfBirth.text = eventParticipant?.evDob?.formattedDate(inputPattern: .FORMAT_YYYY_MM_DD_HIPHEN, outputFormat: .FORMAT_DD_MMM_YYYY) ?? "-"
        email.text = eventParticipant?.email ?? "-"
        orderId.text = "#"
        orderId.text?.append(eventParticipant?.orderID ?? "-")
        
      if eventParticipant?.isSignEnabled ?? false{
            var image = UIImage(named: "sign_green") as UIImage?
            if eventParticipant?.hasSignature ?? false{
                if !AppEngine.sharedInstance.isEvApp(){
                    image = UIImage(named: "admin_moto_signature") as UIImage?
                }
            }else{
                image = UIImage(named: "sign") as UIImage?
                
            }
           
            btnSign?.setImage(image, for: .normal)
            
        }
        if (eventParticipant?.hasAccessories ?? false) == false{
            if btnTraining != nil && btnTraining.isHidden == false{
                btnTraining.isHidden = true
            }
        }else{
            var image = UIImage(named: "star") as UIImage?
            if !AppEngine.sharedInstance.isEvApp(){
                image = UIImage(named: "admin_moto_star") as UIImage?
            }
            if(btnTraining != nil){
                btnTraining.setImage(image, for: .normal)
            }
        }
        
        if AppEngine.sharedInstance.isEvApp(){
            btnMotoIcon.setImage(UIImage(named: "ic_moto_green"), for: .normal)
            tdPurchaseWarning.setImage(UIImage(named: "ic_td_not_purchased"), for: .normal)
        }else{
            btnMotoIcon.setImage(UIImage(named: "ic_moto_blue"), for: .normal)
            tdPurchaseWarning.setImage(UIImage(named: "ic_td_not_purchased_blue"), for: .normal)
        }
        backroundView.backgroundColor = UIColor.init(hexFromString: "e6e6e6")
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 0.8)
        containerView.setCardView()
        
        
        if AppEngine.sharedInstance.isEvApp(){
            
            btnMotoIcon.isHidden = !(eventParticipant?.motoPurchased ?? false)
            tdPurchaseWarning.isHidden = !((eventParticipant?.motoPurchased ?? false) && !(eventParticipant?.tdPurchased ?? false))
        }else{
            
            btnMotoIcon.isHidden = false
            tdPurchaseWarning.isHidden = true
                
        }
         
        
        userName.textColor = UIColor.getAppThemeColor()
         userID.textColor = UIColor.getAppThemeColor()
         skill.textColor = UIColor.getAppThemeColor()
         dateOfBirth.textColor = UIColor.getAppThemeColor()
         email.textColor = UIColor.getAppThemeColor()
         orderId.textColor = UIColor.getAppThemeColor()
    }
    
    
    @IBAction func didPressTrainingButton(_ sender: UIButton) {
        delegate?.clickedOnAccessories(self, participant: eventParticipant)
    }
    
    @IBAction func didPressSignButton(_ sender: UIButton) {
        delegate?.clickedOnSignature(self, participant: eventParticipant)
    }
    
    
    @IBAction func didPressUpgradeSkill(_ sender: UIButton) {
        delegate?.clickedOnUpgradeSkill(self, participant: eventParticipant)
    }
    
    
    @IBAction func didPressMotoIcon(_ sender: Any) {
        delegate?.clickedOnMotoIcon(self, participant: eventParticipant)
    }
}
