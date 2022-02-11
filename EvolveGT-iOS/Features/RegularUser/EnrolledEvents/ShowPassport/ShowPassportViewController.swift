//
//  ShowPassportViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 26/01/22.
//  Copyright © 2022 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
class ShowPassportController : ETViewController, PassportViewDelegate{
    
    static let identifier = "ShowPassportController"
    @IBOutlet weak var passportImage: UIImageView!
    @IBOutlet weak var groupuBadge: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMembership: UILabel!
    
    @IBOutlet weak var lblTraining: UILabel!
    
    @IBOutlet weak var lblRentals: UILabel!
    
    @IBOutlet weak var lblDayWork: UILabel!
    let interactor = ShowPassportInteractor()
    
    @IBOutlet weak var selfieDate: UILabel!
    
    
    @IBOutlet weak var lblEventDate: UILabel!
    @IBOutlet weak var trackName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetUi()
        self.ext.showNavbar()
        self.ext.showBackButton()
        
        interactor.passportDelegate = self
        interactor.delegate = self
        
        interactor.fetchPassportInfo()
        
        
    }
    override func getScreenTitle() -> String? {
        "View Passport"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ext.showNavbar()
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillDisappear(animated)
        self.ext.hideNavbar()
    }
    func onPassportFetched(_ passportInfo: PassportInfo) {
        self.passportImage.superview?.setCardView()
        if let imgUrl = passportInfo.picture{
            
            let placeHolder = UIImage(named: "et_fallback_image")
            self.passportImage.kf.setImage(with: URL(string : imgUrl), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
            
        }
        if passportInfo.dayWorkerJob?.isEmpty ?? true{
            if let imgUrl = passportInfo.groupLogo{
                
                let placeHolder = UIImage(named: "et_fallback_image")
                self.groupuBadge.kf.setImage(with: URL(string : imgUrl), placeholder: placeHolder, options: [.transition(ImageTransition.fade(1))])
                
            }
            lblDayWork.text = ""
        }else{
            groupuBadge.isHidden = true
            lblDayWork.text = "Job: \(passportInfo.dayWorkerJob!)"
        }
        lblName.text = passportInfo.riderName ?? "" + " (\(passportInfo.skillLevel ?? ""))"
        lblMembership.text = "Membership Level: \(passportInfo.membershipLevel ?? "")"
        if passportInfo.allRentals.isEmpty{
            lblRentals.text = "Rentals: NA"
        }else{
            lblRentals.text = "Rentals: \(passportInfo.allRentals)"
        }
        
        if passportInfo.allTrainings.isEmpty{
            lblTraining.text = "Trainings: NA"
        }else{
            lblTraining.text = "Trainings: \(passportInfo.allTrainings)"
        }
        if  passportInfo.signedDate?.isEmpty ?? true{
            selfieDate.isHidden = true
        }else{
            selfieDate.isHidden = false
            selfieDate.text = " Date: \(passportInfo.signedDate!.formattedDate(inputPattern: .FORMAT_MMMM_YYYY_DD_HH_MM_SS, outputFormat: .FORMAT_DD_MMM_YYYY)) "
        }
        trackName.textColor = .getAppThemeColor()
        lblEventDate.textColor = .getAppThemeColor()
        trackName.text = AppEngine.sharedInstance.trackName
        let eventDate = "Event Date: \(AppEngine.sharedInstance.eventDate.formattedDate(inputPattern: .FORMAT_YYYY_MM_DD_HIPHEN, outputFormat: .FORMAT_DD_MMM_YYYY))"
        lblEventDate.text = eventDate
    }
    
    func resetUi() {
        self.passportImage.superview?.setCardView()
        let placeHolder = UIImage(named: "et_fallback_image")
        self.passportImage.image = placeHolder
        self.groupuBadge.image = placeHolder
        lblDayWork.text = ""
        lblName.text = ""
        lblRentals.text = ""
        lblTraining.text = ""
        lblMembership.text = ""
        trackName.text = ""
        lblEventDate.text = ""
        
    }
}
