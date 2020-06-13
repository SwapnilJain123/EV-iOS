//
//  HomeViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import SideMenuSwift

class HomeViewController: TabbedViewController{
    
    @IBOutlet weak var profileView: UITableView!
    
    var profileData : ProfileData? = nil
    var sections = [HomeSection]()
    
    
    var upComingEventsExpanded = true
    var pastEventsExpanded = false
    var creditHistoryExpanded = false
    
    let interactor = HomeDataInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        profileView.rowHeight = UITableView.automaticDimension
        profileView.estimatedRowHeight = 300
        interactor.delegate = self
        
    }
    
    override  func didChangeAppTheme() {
        super.didChangeAppTheme()
        profileData?.upComingEventsCount = 0
        profileData?.pastEventsCount = 0
        profileData?.allEventsCount = 0
        profileData?.recentPastEvent = nil
        profileData?.recentUpComingEvent = nil
        profileData?.recentCreditHistory = nil
        
        self.profileView.reloadData()
        interactor.fetchUserDetails()
        
    }
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_DASHBOARD
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor.fetchUserDetails()
    }
    
    func launchCoachDutiesController(){
        interactor.fetchCoachDuties()
    }
}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.sections[indexPath.row] {
        case .profile:
            let profileCell = tableView.dequeueReusableCell(withIdentifier:"HomeProfileCell",for: indexPath) as! ProfileCell
            
            profileCell.showData(self.profileData!)
            return profileCell
        case .coachDuties:
            let cell = tableView.dequeueReusableCell(withIdentifier:CoachDutyCell.identifier,for: indexPath) as! CoachDutyCell
            
            cell.setUp{
                self.launchCoachDutiesController()
            }
            return cell
        case .upcomingEvents:
            if self.profileData?.recentUpComingEvent == nil{
                let emptyInfoCell = tableView.dequeueReusableCell(withIdentifier:"HomeEmptyCell",for: indexPath) as! EmptyCell
                emptyInfoCell.showData(ScreenTitle.TITLE_UPCOMING_EVENTS, ErrorMessages.emptyEnrolledEvents)
                return emptyInfoCell
            }else{
                let upComingEventCell = tableView.dequeueReusableCell(withIdentifier:"UpcomingEventCell",for: indexPath) as! SectionEventInfoCell
                
                upComingEventCell.populateViews(type: .UPCOMING, profileData!.recentUpComingEvent!, expanded: upComingEventsExpanded)
                upComingEventCell.delegate = self
                return upComingEventCell
            }
        case .pastEvents:
            if self.profileData?.recentPastEvent == nil{
                let emptyInfoCell = tableView.dequeueReusableCell(withIdentifier:"HomeEmptyCell",for: indexPath) as! EmptyCell
                emptyInfoCell.showData(ScreenTitle.TITLE_PAST_EVENTS, ErrorMessages.emptyEnrolledEvents)
                return emptyInfoCell
            }else{
                let pastEventCell = tableView.dequeueReusableCell(withIdentifier:"PastEventCell",for: indexPath) as! SectionEventInfoCell
                pastEventCell.delegate = self
                pastEventCell.populateViews(type: .PAST, profileData!.recentPastEvent!, expanded: pastEventsExpanded)
                return pastEventCell
            }
        case .creditHistory:
            if self.profileData?.recentCreditHistory == nil{
                let emptyInfoCell = tableView.dequeueReusableCell(withIdentifier:"HomeEmptyCell",for: indexPath) as! EmptyCell
                emptyInfoCell.showData(ScreenTitle.TITLE_CREDIT_HISTORY, ErrorMessages.emptyCreditList)
                return emptyInfoCell
            }else{
                let creditCell = tableView.dequeueReusableCell(withIdentifier:"RecentCreditCell",for: indexPath) as! CreditHistoryCell
                creditCell.delegate = self
                creditCell.showData(profileData!.recentCreditHistory!, expanded: creditHistoryExpanded)
                return creditCell
            }
            
        }
        
    }
    
}

extension HomeViewController: HomeViewDelegate{
    func didFetchCoachDuties(assignedEvents: [AssignedEvent]) {
        if assignedEvents.count == 1{
            let vc = self.ext.getViewController(storyBoard: "CoachDuties", VCIdentifier: "CoachDutiesVC") as! CoachDutiesController
            vc.assignedEvent = assignedEvents.first
            self.ext.pushViewController(viewController: vc)
        }else{
            let vc = self.ext.getViewController(storyBoard: "CoachDuties", VCIdentifier: "TabbedCoachDutiesVC") as! TabbedCoachDutiesController
            vc.assignedEvents = assignedEvents
            self.ext.pushViewController(viewController: vc)
        }
    }
    
    func didFetchDetails(profileData: ProfileData?, sections: [HomeSection]) {
        self.profileData = profileData
        self.sections = sections
        profileView.reloadData()
    }
    
}
extension HomeViewController: EventCellDelegate, CreditHistoryCellDelegate{
    func showEnrolledEventList(type: EventType) {
        //
        self.ext.pushViewController(storyBoard: "EnrolledEvents", VCIdentifier: "EventsTab")
    }
    
    func showCreditLists() {
        self.ext.pushViewController(storyBoard: "CreditHistory", VCIdentifier: "CreditHistoryViewController")
    }
    
    func toggleCreditDetailsView() {
        self.creditHistoryExpanded = !self.creditHistoryExpanded
        let index = self.sections.index(of: .creditHistory) ?? sections.count - 1
        let indexPath = IndexPath(row: index, section: 0)
        self.profileView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        
        if self.creditHistoryExpanded{
            scrollToRow(row: index)
        }
    }
    
    func toggleEventDetails(type: EventType) {
        
        if type == .UPCOMING{
            
            self.upComingEventsExpanded = !self.upComingEventsExpanded
            let defaultIndex = sections.contains(.coachDuties) ? 2 : 1
            let index = self.sections.index(of: .upcomingEvents) ?? defaultIndex
            let indexPath = IndexPath(row: index, section: 0)
            self.profileView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            
        }else {
            self.pastEventsExpanded = !self.pastEventsExpanded
            
            let defaultIndex = sections.contains(.coachDuties) ? 3 : 2
            let index = self.sections.index(of: .pastEvents) ?? defaultIndex
            let indexPath = IndexPath(row: index, section: 0)
            self.profileView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            scrollToRow(row: index)
        }
        
    }
    
    func scrollToRow(row: Int){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: row, section: 0)
            self.profileView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
