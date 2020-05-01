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
    
    @IBOutlet weak var btnTraining: UIButton!
    @IBOutlet weak var btnSign: UIButton!
    @IBOutlet weak var btnSkillUpgrade: UIButton!
    
    @IBOutlet weak var backroundView: UIView!
    
    
    func updateUI() {
        userName.text = eventParticipant?.namewithRole ?? "-"
        skill.text = eventParticipant?.skillLevel
        userID.text! = "#"
        userID.text?.append(eventParticipant?.userID ?? "-")
        dateOfBirth.text = eventParticipant?.evDob?.formattedDate(outputFormat: .FORMAT_DD_MMM_YYYY) ?? "-"
        email.text = eventParticipant?.email ?? "-"
        orderId.text = "#"
        orderId.text?.append(eventParticipant?.orderID ?? "-")
        
        //btnTraining.isHidden = !(eventParticipant?.hasTrainingOrRentals ?? false)
        // btnSign.isHidden = eventParticipant?.signEnabled == 1 ? false : true
        if eventParticipant?.signEnabled != 1 {
            if btnSign != nil &&  btnSign.isHidden == false{
                btnSign.removeFromSuperview()
            }
            
        }else{
            if eventParticipant?.hasSignature ?? false{
                //green or blue
                let image = UIImage(named: "sign_green") as UIImage?
                btnSign.setImage(image, for: .normal)
            }else{
                //red icon
                let image = UIImage(named: "sign") as UIImage?
                btnSign.setImage(image, for: .normal)
            }
        }
        if !(eventParticipant?.hasTrainingOrRentals ?? false){
            if btnTraining != nil && btnTraining.isHidden == false{
                btnTraining.removeFromSuperview()
            }
        }
        
        backroundView.backgroundColor = UIColor.init(hexFromString: "e6e6e6")
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 0.8)
        containerView.setCardView()
        
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
}
