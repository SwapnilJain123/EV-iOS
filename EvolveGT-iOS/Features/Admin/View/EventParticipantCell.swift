//
//  EventParticipantCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 23/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

protocol EventParticipantDelegate  {
    func clickedOnSignature(_ cell: EventParticipantCell, event: EventParticipant?)
    func clickedOnUpgradeSkill(_ cell: EventParticipantCell, event: EventParticipant?)
    func clickedOnTraining(_ cell: EventParticipantCell, trainingInfo: [String])
}

class EventParticipantCell: UITableViewCell{
    
    
    var eventParticipant: EventParticipant? {
        didSet {
            updateUI()
        }
    }
    
    var delegate : EventParticipantDelegate?
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var skill: UILabel!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var dateOfBirth: UILabel!
    @IBOutlet weak var orderId: UILabel!
    
    
    @IBOutlet weak var btnTraining: UIButton!
    
    @IBOutlet weak var btnSign: UIButton!
    
    
    @IBOutlet weak var btnSkillUpgrade: UIButton!
    
    func updateUI() {
        userName.text = eventParticipant?.namewithRole ?? "-"
        skill.text = eventParticipant?.skillLevel
        userID.text! = "#"
        userID.text?.append(eventParticipant?.userID ?? "-")
        dateOfBirth.text = eventParticipant?.evDob?.formattedDate(outputFormat: .FORMAT_DD_MMM_YYYY) ?? "-"
        email.text = eventParticipant?.email ?? "-"
        orderId.text = "#"
        orderId.text?.append(eventParticipant?.orderID ?? "-")
        
        btnTraining.isHidden = eventParticipant?.rentals?.isEmpty ?? true
        btnSign.isHidden = eventParticipant?.signEnabled == 1 ? false : true
        
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
    /*
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
 */
}
