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
    
    
    var upComingEventsExpanded = true
    var pastEventsExpanded = false
    var creditHistoryExpanded = false
    
    let interactor = HomeDataInteractor()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileView.rowHeight = UITableView.automaticDimension
        profileView.estimatedRowHeight = 300
        
        interactor.delegate = self
        interactor.fetchUserDetails()
        
        setNavbarControls()
    }
    
    func setNavbarControls(){
        
        
        var switcIcon = UIImage(named: "switch_moto")
        if !AppEngine.sharedInstance.isEvApp(){
            switcIcon = UIImage(named: "switch_ev")
        }
        
        let switchAppMode = UIBarButtonItem(image: switcIcon,
                                            style: .plain,
                                            target: self,
                                            action: #selector(self.switchAppMode))
        
        self.navigationItem.rightBarButtonItems = [switchAppMode]
    
        enableSlideMenu()
        
    }
    
    
    override  func didChangeAppTheme() {
        setNavbarControls()
        self.profileView.reloadData()
        interactor.fetchUserDetails()
        
    }
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_DASHBOARD
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.ext.showBackButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ext.showNavbar()
        self.ext.hideBackButton()
    }
}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Log.d("Profile Data - \(self.profileData == nil)")
        return self.profileData == nil ? 0 : 4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            let profileCell = tableView.dequeueReusableCell(withIdentifier:"HomeProfileCell",for: indexPath) as! ProfileCell
            
            profileCell.showData(self.profileData!)
            return profileCell;
        }else if indexPath.row == 1 {
            
            if self.profileData?.recentUpComingEvent == nil{
                let emptyInfoCell = tableView.dequeueReusableCell(withIdentifier:"HomeEmptyCell",for: indexPath) as! EmptyCell
                emptyInfoCell.showData(ScreenTitle.TITLE_UPCOMING_EVENTS, ErrorMessages.emptyEnrolledEvents)
                return emptyInfoCell
            }else{
                let upComingEventCell = tableView.dequeueReusableCell(withIdentifier:"EventCell",for: indexPath) as! EventInfoCell
                
                upComingEventCell.populateViews(type: .UPCOMING, profileData!.recentUpComingEvent!, expanded: upComingEventsExpanded)
                upComingEventCell.delegate = self
                return upComingEventCell;
            }
            
        }else if indexPath.row == 2 {
            
            if self.profileData?.recentPastEvent == nil{
                let emptyInfoCell = tableView.dequeueReusableCell(withIdentifier:"HomeEmptyCell",for: indexPath) as! EmptyCell
                emptyInfoCell.showData(ScreenTitle.TITLE_PAST_EVENTS, ErrorMessages.emptyEnrolledEvents)
                return emptyInfoCell
            }else{
                let pastEventCell = tableView.dequeueReusableCell(withIdentifier:"EventCell",for: indexPath) as! EventInfoCell
                pastEventCell.delegate = self
                pastEventCell.populateViews(type: .PAST, profileData!.recentPastEvent!, expanded: pastEventsExpanded)
                return pastEventCell;
            }
            
            
        }else if indexPath.row == 3 {
            
            if self.profileData?.recentCreditHistory == nil{
                let emptyInfoCell = tableView.dequeueReusableCell(withIdentifier:"HomeEmptyCell",for: indexPath) as! EmptyCell
                emptyInfoCell.showData(ScreenTitle.TITLE_CREDIT_HISTORY, ErrorMessages.emptyCreditList)
                return emptyInfoCell
            }else{
                let creditCell = tableView.dequeueReusableCell(withIdentifier:"RecentCreditCell",for: indexPath) as! CreditHistoryCell
                creditCell.delegate = self
                creditCell.showData(profileData!.recentCreditHistory!, expanded: creditHistoryExpanded)
                return creditCell;
            }
            
            
        }else {
            let emptyInfoCell = tableView.dequeueReusableCell(withIdentifier:"HomeEmptyCell",for: indexPath)
            Log.d("Empty Cell")
            return emptyInfoCell
        }
        
        
    }
    
}

extension HomeViewController: HomeViewDelegate{
    func didFetchDetails(profileData: ProfileData?) {
        
        Log.d("Profile Data Fetched")
        self.profileData = profileData
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
        let indexPath = IndexPath(row: 3, section: 0)
        self.profileView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        
        if self.creditHistoryExpanded{
            scrollToRow(row: 3)
        }
    }
    
    func toggleEventDetails(type: EventType) {
        if type == .UPCOMING{
            self.upComingEventsExpanded = !self.upComingEventsExpanded
            let indexPath = IndexPath(row: 1, section: 0)
            self.profileView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            
        }else {
            self.pastEventsExpanded = !self.pastEventsExpanded
            let indexPath = IndexPath(row: 2, section: 0)
            self.profileView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            scrollToRow(row: 2)
        }
        
    }
    
    func scrollToRow(row: Int){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: row, section: 0)
            self.profileView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
