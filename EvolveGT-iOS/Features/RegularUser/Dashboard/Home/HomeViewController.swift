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
import FirebaseMessaging

class HomeViewController: TabbedViewController{
    
    @IBOutlet weak var profileView: UITableView!
    
    var profileData : ProfileData? = nil
    var sections = [HomeSection]()
    
    var upComingEventsExpanded = true
    var pastEventsExpanded = false
    var creditHistoryExpanded = false
    
    let interactor = HomeDataInteractor()
    private var badgeCount: Int = 0
    private var badgeView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let value = UserDefaults.standard.string(forKey: "isLogout") else {
            UserDefaults.standard.set("true", forKey: "isLogout")
            self.dashboardManager.logout()
            return
        }
        
        self.view.backgroundColor = UIColor.getAppThemeColor()
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.getAppThemeColor()
        profileView.rowHeight = UITableView.automaticDimension
        profileView.estimatedRowHeight = 300
        interactor.delegate = self
        interactor.homeViewDelegate = self
        messagingToken()

    }
    
    private func createBadgeView() -> UIView {
        let badgeView = UIView(frame: CGRect(x: 22, y: -05, width: 20, height: 20))
        badgeView.backgroundColor = .red
        badgeView.layer.cornerRadius = badgeView.frame.height / 2
        
        let label = UILabel(frame: badgeView.bounds)
        label.text = "" // Initially empty
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        badgeView.addSubview(label)
        
        return badgeView
    }
    
    func messagingToken() {
        DispatchQueue.main.async() {
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("Error fetching remote instance ID: \(error)")
                } else if let token = token {
                    print("Firebase registration token (didBecomeActive): \(token)")
                    UserDefaults.standard.set(token, forKey: AppConstants.DEVICE_TOKEN)
                    UserDefaults.standard.synchronize()
                    self.interactor.updateDeviceToken()
                }
            }
        }
    }
    
    func setBadgeCount(count: Int) {
        badgeCount = count
        let badgeLabel = badgeView.subviews.first as! UILabel // Assuming only one subview (label)
        badgeLabel.text = count > 0 ? "\(count)" : "" // Hide badge if count is 0
        
        // Optionally adjust badge size based on count (example for max 2 digits):
        let width = String(count).width(withConstrainedHeight: 20, font: badgeLabel.font!) + 10
        badgeView.frame.size.width = min(width, 25) // Limit max width to 25
        
        // Optionally animate badge appearance/disappearance (using simple alpha animation)
        if count > 0 {
            badgeView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.badgeView.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.badgeView.alpha = 0
            } completion: { _ in
                // Optional: Hide badge view completely if count is 0 (for better layout)
                self.badgeView.isHidden = true
            }
        }
    }
    override  func didChangeAppTheme() {
        super.didChangeAppTheme()
        
        resetProfileData()
        interactor.fetchUserDetails()
    }
    
    func resetProfileData(){
        profileData?.upComingEventsCount = 0
        profileData?.pastEventsCount = 0
        profileData?.allEventsCount = 0
        profileData?.recentPastEvent = nil
        profileData?.recentUpComingEvent = nil
        profileData?.recentCreditHistory = nil
        self.profileView.reloadData()
    }
    
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_DASHBOARD
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        resetProfileData()
        interactor.fetchUserDetails()
        interactor.syncCartBadgeCount()
    }
    
    func launchCoachDutiesController(){
        interactor.fetchCoachDuties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if appDelegate?.isCameraOpen == true {
            appDelegate?.isCameraOpen = false
            appDelegate?.launchDashboard(payload: nil)
        }
    }
    
    @objc func cartAction(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 3
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
            profileCell.delegate = self
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
                
                if upComingEventsExpanded{
                    let upComingEventCell = tableView.dequeueReusableCell(withIdentifier:"UpcomingEventCell",for: indexPath) as! SectionEventInfoCell
                    
                    upComingEventCell.populateViews(type: .UPCOMING, profileData!.recentUpComingEvent!)
                    upComingEventCell.delegate = self
                    return upComingEventCell
                }else{
                    let collaspedCell = tableView.dequeueReusableCell(withIdentifier:CollapsedCell.identifier,for: indexPath) as! CollapsedCell
                    collaspedCell.populateUi(title: ScreenTitle.TITLE_UPCOMING_EVENTS){
                        self.upComingEventsExpanded = true
                        self.profileView.reloadRows(at: [indexPath], with: .automatic)
                        self.scrollToRow(row: indexPath.row)
                    }
                    return collaspedCell
                }
                
            }
        case .pastEvents:
            if self.profileData?.recentPastEvent == nil{
                let emptyInfoCell = tableView.dequeueReusableCell(withIdentifier:"HomeEmptyCell",for: indexPath) as! EmptyCell
                emptyInfoCell.showData(ScreenTitle.TITLE_PAST_EVENTS, ErrorMessages.emptyEnrolledEvents)
                return emptyInfoCell
            }else{
                
                if(pastEventsExpanded){
                    let pastEventCell = tableView.dequeueReusableCell(withIdentifier:"PastEventCell",for: indexPath) as! SectionEventInfoCell
                    pastEventCell.delegate = self
                    pastEventCell.populateViews(type: .PAST, profileData!.recentPastEvent!)
                    return pastEventCell
                }else{
                    let collaspedCell = tableView.dequeueReusableCell(withIdentifier:CollapsedCell.identifier,for: indexPath) as! CollapsedCell
                    collaspedCell.populateUi(title: ScreenTitle.TITLE_PAST_EVENTS){
                        self.pastEventsExpanded = true
                        self.profileView.reloadRows(at: [indexPath], with: .automatic)
                        self.scrollToRow(row: indexPath.row)
                    }
                    return collaspedCell
                }
                
            }
        case .creditHistory:
            if self.profileData?.recentCreditHistory == nil{
                let emptyInfoCell = tableView.dequeueReusableCell(withIdentifier:"HomeEmptyCell",for: indexPath) as! EmptyCell
                emptyInfoCell.showData(ScreenTitle.TITLE_CREDIT_HISTORY, ErrorMessages.emptyCreditList)
                return emptyInfoCell
            }else{
                
                if creditHistoryExpanded{
                    let creditCell = tableView.dequeueReusableCell(withIdentifier:"RecentCreditCell",for: indexPath) as! CreditHistoryCell
                    creditCell.delegate = self
                    creditCell.showData(profileData!.recentCreditHistory!, expanded: creditHistoryExpanded)
                    return creditCell
                }else{
                    let collaspedCell = tableView.dequeueReusableCell(withIdentifier:CollapsedCell.identifier,for: indexPath) as! CollapsedCell
                    collaspedCell.populateUi(title:ScreenTitle.TITLE_CREDIT_HISTORY){
                        self.creditHistoryExpanded = true
                        self.profileView.reloadRows(at: [indexPath], with: .automatic)
                        self.scrollToRow(row: indexPath.row)
                    }
                    return collaspedCell
                }
                
            }
            
        case .referAFriend:
            let referFriendCell = tableView.dequeueReusableCell(withIdentifier:"ReferFriendCell",for: indexPath) as! ReferAFriendCell
            referFriendCell.action = {
                let VC = self.ext.getViewController(storyBoard: "ReferFriend", VCIdentifier: "referFriendVC")
                
                VC.providesPresentationContextTransitionStyle = true
                VC.definesPresentationContext = true
                VC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                VC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                
                
                self.present(VC, animated: true, completion: nil)
                
            }
            referFriendCell.updateUi()
            return referFriendCell
            
        }
        
    }
    
}

extension HomeViewController: HomeViewDelegate{
    
    func didFetchCoachDuties(assignedEvents: AssignedDuty) {
        /*
         if assignedEvents.count == 1{
         
         }else{
         let vc = CoachDutiesSlidingTabController()
         vc.assignedEvents = assignedEvents
         self.ext.pushViewController(viewController: vc)
         }
         */
        let vc = self.ext.getViewController(storyBoard: "CoachDuties", VCIdentifier: "CoachDutiesVC") as! CoachDutiesController
        vc.assignedDuty = assignedEvents
        self.ext.pushViewController(viewController: vc)
    }
    
    func didFetchDetails(profileData: ProfileData?, sections: [HomeSection]) {
        self.profileData = profileData
        self.sections = sections
        
        // First Button (Cart)
        let cartButton = UIButton(type: .custom)
        cartButton.setImage(UIImage(named: "cart_a"), for: .normal)
        
        cartButton.addTarget(self, action: #selector(cartAction), for: .touchUpInside)
        badgeView = createBadgeView()
        cartButton.addSubview(badgeView)
        setBadgeCount(count: AppEngine.sharedInstance.cartListCount)
        
        let cartBarButtonItem = UIBarButtonItem(customView: cartButton)
        
        let notificationBtn = UIButton(type: .custom)
        notificationBtn.setImage(UIImage(named: "notification"), for: .normal)
        notificationBtn.addTarget(self, action: #selector(notificationList), for: .touchUpInside)
      //  notificationBtn.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        
        let secondBarButtonItem = UIBarButtonItem(customView: notificationBtn)
        
        // Add both buttons to the navigation bar
        navigationItem.rightBarButtonItems = [cartBarButtonItem, secondBarButtonItem]
        profileView.reloadData()
    }
    
    @objc func notificationList() {
        let vc = self.ext.getViewController(storyBoard: "Home", VCIdentifier: "NotificationViewController") as! NotificationViewController
        self.ext.pushViewController(viewController: vc)
    }
    
}
extension HomeViewController: EventCellDelegate, CreditHistoryCellDelegate{
    func showEnrolledEventList(type: EventType) {
        //        let vc = EnrolledEventsSlidingTabController()
        //        vc.selectedIndex = type == EventType.PAST ? EnrolledEventsSlidingTabController.TAB_PAST: EnrolledEventsSlidingTabController.TAB_UPCOMING
        //        self.ext.pushViewController(viewController: vc)
        
        //
        let vc = self.ext.getViewController(storyBoard: "EnrolledEvents", VCIdentifier: "EventHistoryController") as! EventHistoryController
        vc.selectedIndex = type == EventType.PAST ? EnrolledEventsSlidingTabController.TAB_PAST: EnrolledEventsSlidingTabController.TAB_UPCOMING
        
        self.ext.pushViewController(viewController: vc)
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
extension HomeViewController: ProfileCellDelegate{
    func openEventHistory(eventType: Int) {
        let vc = self.ext.getViewController(storyBoard: "EnrolledEvents", VCIdentifier: "EventHistoryController") as! EventHistoryController
        vc.selectedIndex = eventType
        self.ext.pushViewController(viewController: vc)
    }
    
}

extension String {
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return boundingBox.width
    }
}

extension Notification.Name {
    static let logoutNotification = Notification.Name("logoutNotification")
}
