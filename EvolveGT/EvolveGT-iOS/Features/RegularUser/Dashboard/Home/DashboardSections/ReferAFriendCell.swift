//
//  ReferAFriendCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 26/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
class ReferAFriendCell : UITableViewCell{
    
    @IBOutlet weak var icon: UIImageView!
    
    var action: (() -> Void)? = nil
    
    @IBOutlet weak var actionButton: UIButton!
    func updateUi(){
        if AppEngine.sharedInstance.isEvApp(){
            icon.image = UIImage(named: "refer_a_friend")
        }else{
            icon.image = UIImage(named: "refer_a_friend_moto")
        }
        
        actionButton.applyBoarderColorTheme()
        icon.superview?.setCardView()
    }
    
    @IBAction func didPressReferAFriend(_ sender: Any) {
        if let btnAction = action{
            btnAction()
        }
    }
    
}
