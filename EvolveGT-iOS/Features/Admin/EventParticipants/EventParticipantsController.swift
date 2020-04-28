//
//  EventParticipantsController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 23/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SnapKit
class EventParticipantsController : ETViewController{
    
    var completedEvent : CompletedEvent?
    var participants = [EventParticipant]()
    
    @IBOutlet weak var listErrorLable: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var eventBanner: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var particiapntTable: UITableView!
    @IBOutlet weak var eventShortInfoStack: UIStackView!
    
    let interactor = EventParticipantIntercator()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.delegate = self
        particiapntTable.dataSource = self
        
        setUpSearchBar()
        self.showBackButton()
        setupUI()
        setNavbarControls()
        requestEventParticipants()
    
    }
    
    func setUpSearchBar(){
        searchBar?.delegate = self
        searchBar?.placeholder = "Search participants here"
        searchBar?.becomeFirstResponder()
        searchBar?.showsCancelButton = true
        hideSearchbar()
    }
    func setNavbarControls(){
        self.showBackButton()
        self.setScreenTitle(title: ScreenTitle.TITLE_EVENTS)
        
        
        let logoutItem = UIBarButtonItem(image: #imageLiteral(resourceName: "logout_icon"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.didPressLogout))
       
        let searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Search"),
        style: .plain,
        target: self,
        action: #selector(self.searchUsers))
        self.navigationItem.rightBarButtonItems = [logoutItem, searchButton]
    }
    
    @objc func searchUsers(){
        if(searchBar.isHidden){
            searchBar.isHidden = false
            searchBar.snp.remakeConstraints{ make in
                make.height.equalTo(50)
            }
        }else{
            hideSearchbar()
        }
    }
    
    func hideSearchbar(){
        searchBar.isHidden = true
        searchBar.snp.remakeConstraints{ make in
            make.height.equalTo(0)
        }
    }
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_EVENTS_USERS
    }
    
    func requestEventParticipants(){
        interactor.getEventParticipants(completedEvent?.eventID ?? "-1")
    }
    func setupUI(){
        
        searchBar.showsCancelButton = true
        if let url = URL(string: completedEvent?.eventLogo ?? ""){
            let fallbackImage = UIImage(named: "et_fallback_image")
            eventBanner.kf.setImage(with: url,placeholder: fallbackImage,  options: [.transition(ImageTransition.fade(1))])
        }
        eventTitle.text = completedEvent?.title ?? ""
        eventDate.text = completedEvent?.eventDate.formattedDate(outputFormat: .FORMAT_DD_MMM_YYYY) ?? ""
    }
}
extension EventParticipantsController : EventParticipantsViewDelegate{
    func showSuccessMessage(message: String) {
        
    }
    
    func filteredParticipants(participants: [EventParticipant], query: String) {
        self.participants.removeAll()
        self.participants.append(contentsOf: participants)
        particiapntTable.reloadData()
        
        listErrorLable.isHidden = !participants.isEmpty
        listErrorLable.text = "\(ErrorMessages.emptySearchParticipants) \(query)"
    }
    
    func didFetchParticipants(participants: [EventParticipant]) {
        self.participants.removeAll()
        self.participants.append(contentsOf: participants)
        particiapntTable.reloadData()
        listErrorLable.isHidden = true
        
    }
    
    func showProgressIndicator(message: String?) {
        self.addLoadingIndicator()
    }
    
    func hideProgressIndicator() {
        self.removeLoadingIndicator()
    }
    
    func showError(message: String) {
        self.displayEmptyMessage(message: message)
    }
    
}

extension EventParticipantsController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.participants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventParticipantCell",
                                                 for: indexPath) as! EventParticipantCell
        cell.eventParticipant = participants[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let count = participants.count
        if count > 0 {
            if count == 1{
                return "Showing \(count) user"
            }else{
                return "Showing \(count) users"
            }
            
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let count = participants.count
        if count > 0 {
            return 30
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.backgroundView?.backgroundColor = .white
    }
}
extension EventParticipantsController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor.filter(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        interactor.filter("")
        searchBar.resignFirstResponder()
        searchBar.text = ""
        hideSearchbar()
    }
}

extension EventParticipantsController: EventParticipantCellDelegate{
    func clickedOnSignature(_ cell: EventParticipantCell, participant: EventParticipant?) {
        Log.i("Signature Tap identified")
    }
    
    func clickedOnUpgradeSkill(_ cell: EventParticipantCell, participant: EventParticipant?) {
        self.presentSelectionMenu(title: "Upgrade Skill Level", data: AppConstants.SkillLevels){
            selectedItems in
            
            if let skill = selectedItems.first{
                self.interactor.upgradeSkill(skill: skill, userID: participant!.userID)
            }
        }
    }
    
    func clickedOnTraining(_ cell: EventParticipantCell, participant: EventParticipant?) {
        Log.i("Training Tap identified")
    }
    
    
}
