//
//  EWaiverDetailsViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 05/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit
import MBRadioCheckboxButton
import WebKit
import Kingfisher

class EWaiverDetailsViewController: ETViewController , WaiverDetailsDelegate ,  WKUIDelegate  {
    func fetchedWaiverDetails(eventData: EventData, userData: UserData?, stateList: [State]?) {
        self.userData = userData ?? UserData()
        self.eventData = eventData
        self.states = stateList ?? [State]()
        termsAndConditionsWebView.uiDelegate = self
        
        termsAndConditionsWebView.loadHTMLString(eventData.termsHTML ?? "", baseURL: nil)
          
        titleLabel.text = eventData.title
        hostedLabel.text = "Hosted by: \(eventData.hosting ?? "")"
        eventDateLabel.text = "Event date: \(eventData.date ?? "")"
        if let url = URL(string: eventData.logo?.toValidatedImageUrl().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""){
            let fallbackImage = UIImage(named: "et_fallback_image")
            imageView.kf.setImage(with: url,placeholder: fallbackImage,  options: [.transition(ImageTransition.fade(1))])
        }
      
        
    }
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hostedLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var termsAndConditionsWebView: WKWebView!
    
    @IBOutlet weak var ternsCheckBox: CheckboxButton!
    @IBAction func signButton(_ sender: UIButton) {
        let vc = self.ext.getViewController(storyBoard: "E-Waiver", VCIdentifier: "signVC") as! SignViewController
        vc.eventID = self.eventID
        vc.userData = self.userData
        vc.eventData = self.eventData
        vc.states = self.states
        
        self.ext.pushViewController(viewController: vc)
        
    }
    
    var eventID = ""
    var userData = UserData()
    var eventData = EventData()
    var states = [State]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.setCardView()
        titleLabel.textColor = UIColor.getAppThemeColor()
        signButton.applyColorTheme()
        self.ext.showNavbar()
        let interactor = EWaiverInteractor()
        interactor.waiverDetailsDelegate = self
        interactor.delegate = self
        interactor.getEWaiverDetails(eventId: eventID)
        ternsCheckBox.delegate = self
        signButton.applyColorTheme()
        ternsCheckBox.applyCheckboxTheme()
        signButton.isEnabled = false
        
        
        
    }
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_WAIVER
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
    
    
}
extension EWaiverDetailsViewController:CheckboxButtonDelegate{
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        signButton.isEnabled = true
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
        
        signButton.isEnabled = false
    }
    
    
}


