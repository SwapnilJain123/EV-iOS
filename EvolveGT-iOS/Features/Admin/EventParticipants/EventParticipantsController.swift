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
    var selectedParticipant : EventParticipant?
    
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
        
        interactor.adminViewDelegate = self
        particiapntTable.dataSource = self
        
        
        setUpSearchBar()
        self.ext.showBackButton()
        setupUI()
        setNavbarControls()
        requestEventParticipants()
        eventTitle.textColor = UIColor.getAppThemeColor()
    }
    
    
    /// Setting up the search bar
    func setUpSearchBar(){
        searchBar?.delegate = self
        searchBar?.placeholder = "Search participants here"
        searchBar?.becomeFirstResponder()
        searchBar?.showsCancelButton = true
        searchBar.resignFirstResponder()
        hideSearchbar()
    }
    func setNavbarControls(){
        self.ext.showBackButton()
        self.ext.setScreenTitle(title: ScreenTitle.TITLE_EVENTS)
        
        let logoutItem = UIBarButtonItem(image: #imageLiteral(resourceName: "logout_icon"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.didPressLogout))
        
        let searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Search"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(self.searchUsers))
        let filter = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(self.didPressFilterOption))
        self.navigationItem.rightBarButtonItems = [logoutItem, searchButton, filter]
    }
    
     @objc func didPressFilterOption(){
        let options = interactor.getAvailableFilterOptions()
        self.ext.presentOptions(title: "Select Filter", message: "", cancelText: "Clear", options: options, selected: nil, preferredStyle: .alert, completionHandler: { selected in
            switch selected{
            case "By Skill Level":
                let skillList = self.interactor.getAvailableSkillLevels()
                self.presentSelectionMenu(title: "Select Skill Level", data: skillList, dismissHandler: { selectedSkill in
                    if(selectedSkill.first != nil){
                    self.interactor.filterBySkillLevel(skill: selectedSkill.first!)
                    }
                })
            case "By Training":
                let trainings = self.interactor.getAvailableTrainings()
                self.presentSelectionMenu(title: "Select Training", data: trainings, dismissHandler: { selectedTraining in
                    if(selectedTraining.first != nil){
                        self.interactor.filterByTraining(training: selectedTraining.first!)
                    }
                })
            case "By Rentals":
                let rentals = self.interactor.getAvailableRentals()
                self.presentSelectionMenu(title: "Select Rental", data: rentals, dismissHandler: { selectedRental in
                    if(selectedRental.first != nil){
                        self.interactor.filterByRentals(selectedRental: selectedRental.first!)
                    }
                })
            default:
                self.interactor.clearFilter()
            }
        })
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
        eventDate.text = completedEvent?.eventDate?.formattedDate(inputPattern: .FORMAT_YYYY_MM_DD_HIPHEN, outputFormat: .FORMAT_DD_MMM_YYYY) ?? ""
    }
}
extension EventParticipantsController : EventParticipantsViewDelegate, SignatureRefreshDelegate{
    func didModifySignature(signatureId: String) {
        interactor.getEventParticipants(completedEvent?.eventID ?? "")
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
    
    
}

extension EventParticipantsController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.participants.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let eventParticipant = participants[indexPath.row]
        var identifier = "EventParticipantCellSignDisabled"
        if eventParticipant.isSignEnabled{
            identifier = "EventParticipantCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                 for: indexPath) as! EventParticipantCell
        cell.eventParticipant = eventParticipant
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
        
        if(tableView == particiapntTable){
            let count = participants.count
            if count > 0 {
                return 30
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) { if(tableView == particiapntTable){
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.backgroundView?.backgroundColor = .white
        }
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
        
        if participant?.hasSignature ?? false{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignaturePreviewViewController") as! SignaturePreviewViewController
            controller.signatureId = participant?.signatureID ?? ""
            navigationController?.pushViewController(controller, animated: true)
        }else{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignatureReader") as! SignatureReaderController
            controller.eventparticipant = participant
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func clickedOnUpgradeSkill(_ cell: EventParticipantCell, participant: EventParticipant?) {
        self.presentSelectionMenu(title: "Upgrade Skill Level", data: AppConstants.SkillLevels){
            selectedItems in
            
            if let skill = selectedItems.first{
                self.interactor.upgradeSkill(skill: skill, userID: participant!.userID)
            }
        }
    }
    
    func clickedOnAccessories(_ cell: EventParticipantCell, participant: EventParticipant?) {
        Log.i("Training Tap identified")
        //self.interactor.onAccessoriesClicked(participant: participant!)
        showListAlert(eventParticiapnt: participant!)
        
    }
    
    func showListAlert(eventParticiapnt: EventParticipant){
    
        let alertService = AlertService()
        let alertVC = alertService.createListAlertController(title: "Accessories", buttonTitle: "OK")
        
        Log.d("Training Count \(eventParticiapnt.trainings?.count ?? 0)")
        Log.d("Rental Count \(eventParticiapnt.rentals?.count ?? 0)")
        
        let alertData = AlertListData()
       
        
        if let trainings = eventParticiapnt.trainings{
           
            alertData.simpleItemsTitle = "Trainings"
            alertData.simpleItems = [String]()
            for training in trainings{
                alertData.simpleItems?.append(training)
            }
        }
        
        if let rentals = eventParticiapnt.rentals{
             alertData.keyValueItemsTitle = "Rentals"
             alertData.keyValueItems = [AlertKeyValue]()
            
            for rental in rentals{
                let keyValue = AlertKeyValue()
                keyValue.key = rental.name.capitalized
                keyValue.value = "\(rental.attribute.capitalized) - \(rental.value.capitalized)" 
                alertData.keyValueItems!.append(keyValue)
                
            }
        }
        alertVC.alertDataList = alertData
        present(alertVC, animated: true)
    }
    
    
}
