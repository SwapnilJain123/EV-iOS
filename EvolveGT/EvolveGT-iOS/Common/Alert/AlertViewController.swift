//
//  AlertViewController.swift
//  Custom Alerts
//
//  Created by Kyle Lee on 2/13/19.
//  Copyright © 2019 Kilo Loco. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var titleHidden = false
    
    var alertTitle = String()
    
    var actionButtonTitle = String()
    
    var buttonAction: (() -> Void)?
    
    var subViews = [UIView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        for view in subViews{
            mainStackView.addArrangedSubview(view)
        }
    }
    
    func setupView() {
        
        titleLabel.text = alertTitle
        actionButton.setTitle(actionButtonTitle, for: .normal)
        actionButton.applyColorTheme()
        //titleView.backgroundColor = UIColor.getAppThemeColor()
        if titleHidden{
            titleView.removeFromSuperview()
        }
        
    }
    
    func addView(child: UIView){
        subViews.append(child)
    }
    @IBAction func didTapCancel(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    
    @IBAction func didTapActionButton(_ sender: Any) {
        
        dismiss(animated: true)
        
        buttonAction?()
    }
    
}
