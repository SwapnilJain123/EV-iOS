//
//  EnrolledEventsTabController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 09/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip

class EnrolledEventsTabController : ButtonBarPagerTabStripViewController{
    static let TAB_UPCOMING = 0
    static let TAB_PAST = 1
    static let TAB_ALL_EVENTS = 2
    
    
    
    var selectedIndex = EnrolledEventsTabController.TAB_UPCOMING
    
    var interactor = EnrolledEventsInteractor()
    
    override func viewDidLoad() {
        
        let appColor = UIColor.getAppThemeColor()
        settings.style.buttonBarBackgroundColor = appColor
        settings.style.buttonBarItemBackgroundColor = appColor
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 4.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?,
            progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = .darkGray
            newCell?.label.textColor = .white
            
            self.title =  newCell?.label.text?.capitalized ?? ""
            
        }
        super.viewDidLoad()
        
        interactor.delegate = self
        interactor.enrolledEventsDelegate = self
       
        fetchEventHistory()
        
    }
    
    func fetchEventHistory(){
         interactor.fetchEventHistory()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.moveToViewController(at: selectedIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        if selectedIndex == EnrolledEventsTabController.TAB_UPCOMING {
            self.title = ScreenTitle.TITLE_UPCOMING_EVENTS.capitalized
        }else if selectedIndex == EnrolledEventsTabController.TAB_PAST {
            self.title = ScreenTitle.TITLE_PAST_EVENTS.capitalized
        }else{
            self.title = ScreenTitle.TITLE_ALL_EVENTS.capitalized
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillDisappear(animated)
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let upcomingEvents = self.ext.getViewController(storyBoard: "EnrolledEvents", VCIdentifier: "UpcomingEvents")
        
        let pastEvents = self.ext.getViewController(storyBoard: "EnrolledEvents", VCIdentifier: "PastEvents")
        
        let allEvents = self.ext.getViewController(storyBoard: "EnrolledEvents", VCIdentifier: "AllEvents")
        
        return [upcomingEvents, pastEvents, allEvents]
    }
}
extension EnrolledEventsTabController : EnrolledEventsViewDelegate, BaseViewDelegate{
    func hideEmptyPageError() {
        self.ext.hideErrorView()
    }
    
    
    func reloadCurrentIndex() {
        let childvc = self.viewControllers[currentIndex] as! TabProtocol
        childvc.reload()
        
    }
    
    func showProgressIndicator(message: String?) {
        self.ext.addLoadingIndicator(message)
    }
    
    func hideProgressIndicator() {
        self.ext.removeLoadingIndicator()
    }
    
    func didFetchAllEvents(events: [EnrolledEvent]) {
        let eventsVC = self.viewControllers[2] as! AllEventsController
        eventsVC.events = events
    }
    
    func didFetchPastEvents(events: [EnrolledEvent]?) {
        let eventsVC = self.viewControllers[1] as! PastEventsController
        eventsVC.events = events
    }
    
    func didFetchUpcomingEvents(events: [EnrolledEvent]?) {
        let eventsVC = self.viewControllers[0] as! UpcomingEventsController
        eventsVC.events = events
    }
    
    func eventsEmpty() {
        let upcomingEventsVC = self.viewControllers[0] as! UpcomingEventsController
        upcomingEventsVC.events = nil
        
        let pastEventsVC = self.viewControllers[1] as! PastEventsController
        pastEventsVC.events = nil
        
        let allEventsVC = self.viewControllers[2] as! AllEventsController
        allEventsVC.events = nil
    }
    func showEmptyPageError(message: String) {
        
    }
    
    func showSuccessToastMessage(message: String) {
        
    }
    
    func showErrorToastMessage(message: String) {
        
    }
    
    func showAlert(title: String, message: String) {
        
    }
    
    
}
