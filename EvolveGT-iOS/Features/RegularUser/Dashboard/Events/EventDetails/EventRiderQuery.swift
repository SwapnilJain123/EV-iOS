//
//  EventRiderQuery.swift
//  EvolveGT-iOS
//
//  Created by Swapnil Jain on 05/04/25.
//  Copyright © 2025 YaraTech. All rights reserved.
//

import UIKit

protocol EventRiderQueryDelegate: AnyObject {
    func didCallAddToCart(with riderQuery: [String:String])
}

class EventRiderQuery: UIViewController {
    
    @IBOutlet weak var lblRiderQuery: UILabel!
    
    @IBOutlet weak var lblGoal: UILabel!
    @IBOutlet weak var lblCoach: UILabel!
    @IBOutlet weak var lblBikeType: UILabel!
    
    @IBOutlet weak var lblErrorGoal: UILabel!
    @IBOutlet weak var lblErrorCoach: UILabel!
    @IBOutlet weak var lblErrorBikeType: UILabel!
    
    @IBOutlet weak var txtvGoal: UITextView!
    @IBOutlet weak var txtCoach: UITextField!
    @IBOutlet weak var txtBikeType: UITextField!
    
    @IBOutlet weak var btnProceed: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var viewPopup: UIView!
    
    weak var delegate: EventRiderQueryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        txtCoach.delegate = self
        txtBikeType.delegate = self
        txtvGoal.delegate = self
    }
    
    func setUI() {
        btnProceed.layer.cornerRadius = 5
        btnProceed.clipsToBounds = true
        
        btnClose.layer.cornerRadius = 5
        btnClose.clipsToBounds = true
        
        viewPopup.layer.cornerRadius = 10
        viewPopup.clipsToBounds = true
       
        lblErrorGoal.isHidden = true
        lblErrorCoach.isHidden = true
        lblErrorBikeType.isHidden = true
        
        txtvGoal.layer.cornerRadius = txtCoach.layer.cornerRadius
        txtvGoal.layer.borderWidth = 0.5
        txtvGoal.layer.borderColor = UIColor.systemGray3.cgColor
        txtvGoal.layer.cornerRadius = 5
        txtvGoal.clipsToBounds = true
    }
}

extension EventRiderQuery {
    @IBAction func btnCloseAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnProceedAction(_ sender: Any) {
        if validateFields() {
            // Proceed with valid data
            let dictRiderData = ["riders_goal": txtvGoal.text!,
                                 "riders_coach": txtCoach.text!,
                                 "riders_biketype": txtBikeType.text!]
            self.dismiss(animated: true) {
                self.delegate?.didCallAddToCart(with: dictRiderData)
            }
        }
    }
}

extension EventRiderQuery {
    func validateFields() -> Bool {
        var isValid = true

        if txtCoach.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            lblErrorCoach.text = "Please specify the goal for this training."
            lblErrorCoach.isHidden = false
            isValid = false
        } else {
            lblErrorCoach.text = ""
            lblErrorCoach.isHidden = true
        }

        if txtBikeType.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            lblErrorBikeType.text = "Please specify a coach."
            lblErrorBikeType.isHidden = false
            isValid = false
        } else {
            lblErrorBikeType.text = ""
            lblErrorBikeType.isHidden = true
        }

        if txtvGoal.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            lblErrorGoal.text = "Please indicate your bike type"
            lblErrorGoal.isHidden = false
            isValid = false
        } else {
            lblErrorGoal.text = ""
            lblErrorGoal.isHidden = true
        }

        return isValid
    }
    
}

extension EventRiderQuery: UITextFieldDelegate, UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtCoach {
            lblErrorCoach.text = ""
            lblErrorCoach.isHidden = true
        } else if textField == txtBikeType {
            lblErrorBikeType.text = ""
            lblErrorBikeType.isHidden = true
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView == txtvGoal {
            lblErrorGoal.text = ""
            lblErrorGoal.isHidden = true
        }
    }
}
