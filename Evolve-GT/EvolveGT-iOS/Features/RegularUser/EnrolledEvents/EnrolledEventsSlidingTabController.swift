//
//  EnrolledEventsSlidingTabController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 29/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class EnrolledEventsSlidingTabController: ETViewController{
    
    static let TAB_UPCOMING = 0
    static let TAB_PAST = 1
    static let TAB_ALL_EVENTS = 2
    
    private let slidingTabController = UISimpleSlidingTabController()
    
    var selectedIndex = TAB_UPCOMING
    
    var interactor = EnrolledEventsInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.delegate = self
        interactor.enrolledEventsDelegate = self
        
    }
    
    func fetchEventHistory(){
        interactor.fetchEventHistory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchEventHistory()
    }
    private func setupUI(){
        
        // navigation
        navigationItem.title = "Event History"
        
        view.backgroundColor = .clear
        view.addSubview(slidingTabController.view)
        
        let upcomingEvents = self.ext.getViewController(storyBoard: "EnrolledEvents", VCIdentifier: "UpcomingEvents") as! UpcomingEventsController
        upcomingEvents.tabHolderController = self
        let pastEvents = self.ext.getViewController(storyBoard: "EnrolledEvents", VCIdentifier: "PastEvents")
        
        let allEvents = self.ext.getViewController(storyBoard: "EnrolledEvents", VCIdentifier: "AllEvents")
        
        // MARK: slidingTabController
        slidingTabController.addItem(item: upcomingEvents, title: ScreenTitle.TITLE_UPCOMING_EVENTS.uppercased())
        slidingTabController.addItem(item: pastEvents, title: ScreenTitle.TITLE_PAST_EVENTS.uppercased())
        slidingTabController.addItem(item: allEvents, title: ScreenTitle.TITLE_ALL_EVENTS.uppercased())
        
        slidingTabController.setHeaderActiveColor(color: .white)
        slidingTabController.setHeaderInActiveColor(color: .lightText)
        slidingTabController.setHeaderBackgroundColor(color: .getAppThemeColor())
        slidingTabController.setCurrentPosition(position: 0)
        slidingTabController.setStyle(style: .flexible)
        slidingTabController.build() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ext.showNavbar()
        DispatchQueue.main.asyncAfter(deadline: .now(), execute:{
            self.setupUI()
            self.slidingTabController.setCurrentPosition(position: self.selectedIndex)
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillDisappear(animated)
        self.ext.hideNavbar()
    }
}
extension EnrolledEventsSlidingTabController : EnrolledEventsViewDelegate{
    
    
    func reloadCurrentIndex() {
        let childvc = slidingTabController.getViewController(at: slidingTabController.getCurrentIndex()) as! SlidingTabDelegate
        childvc.reloadPage()
        
    }
    
    
    
    func didFetchAllEvents(events: [EnrolledEvent]) {
        let eventsVC = slidingTabController.getViewController(at: EnrolledEventsSlidingTabController.TAB_ALL_EVENTS) as! AllEventsController
        eventsVC.events = events
        Log.d("All Events - \(events.count)")
    }
    
    func didFetchPastEvents(events: [EnrolledEvent]?) {
        let eventsVC = slidingTabController.getViewController(at: EnrolledEventsSlidingTabController.TAB_PAST) as! PastEventsController
        eventsVC.events = events
        Log.d("Past Events - \(events?.count ?? -1)")
    }
    
    func didFetchUpcomingEvents(events: [EnrolledEvent]?) {
        let eventsVC = slidingTabController.getViewController(at: EnrolledEventsSlidingTabController.TAB_UPCOMING) as! UpcomingEventsController
        Log.d("Upcoming Events - \(events?.count ?? -1)")
        eventsVC.events = events
    }
    
    func eventsEmpty() {
        let upcomingEventsVC = slidingTabController.getViewController(at: EnrolledEventsSlidingTabController.TAB_UPCOMING) as! UpcomingEventsController
        upcomingEventsVC.events = nil
        
        let pastEventsVC = slidingTabController.getViewController(at: EnrolledEventsSlidingTabController.TAB_PAST) as! PastEventsController
        pastEventsVC.events = nil
        
        let allEventsVC = slidingTabController.getViewController(at: EnrolledEventsSlidingTabController.TAB_ALL_EVENTS) as! AllEventsController
        allEventsVC.events = nil
    }
    
}
