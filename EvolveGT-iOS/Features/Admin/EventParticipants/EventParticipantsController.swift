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

protocol cancelEventDelegete {
    func cancelEvent()
}

class EventParticipantsController : ETViewController, cancelEventDelegete{
 
    var isParticipants = true
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
        interactor.cencelEventDelegate = self
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
        
        if participants.count < 1{
            return
        }
        let options = interactor.getAvailableFilterOptions()
        if options.count < 1 {
            return
        }
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
            case "By Classes":
            let motoClasses = self.interactor.getAvailableMotoClasses()
            self.presentSelectionMenu(title: "Select Moto Class", data: motoClasses, dismissHandler: { selectedClass in
                if(selectedClass.first != nil){
                    self.interactor.filterByMotoClasses(motoClass: selectedClass.first!)
                }
            })
                case "By Not Signed In":
                           self.interactor.filterByUsersNotSignedIn()
            case "By Racers":
                self.interactor.filterByRacers()
            case "By Duties":
                let duties = self.interactor.getAvailableDuties()
                self.presentSelectionMenu(title: "Select Duty", data: duties, dismissHandler: { selectedDuty in
                    if(selectedDuty.first != nil){
                        self.interactor.filterByDuties(query: selectedDuty.first!)
                    }
                })
            default:
                self.interactor.clearFilter()
            }
        })
    }
    @objc func searchUsers(){
        if participants.count > 0{
        if(searchBar.isHidden){
            searchBar.isHidden = false
            searchBar.snp.remakeConstraints{ make in
                make.height.equalTo(50)
            }
        }else{
            hideSearchbar()
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
        interactor.getEventParticipants(completedEvent?.eventID ?? 0, isParticipant: isParticipants)
    }
    
    func setupUI(){
        
        searchBar.showsCancelButton = true
        if let url = URL(string: completedEvent?.eventLogo?.toValidatedImageUrl().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""){
            let fallbackImage = UIImage(named: "et_fallback_image")
            eventBanner.kf.setImage(with: url,placeholder: fallbackImage,  options: [.transition(ImageTransition.fade(1))])
        }
        eventTitle.text = completedEvent?.title ?? ""
        eventDate.text = completedEvent?.eventDate?.formattedDate(inputPattern: .FORMAT_YYYY_MM_DD_HIPHEN, outputFormat: .FORMAT_DD_MMM_YYYY) ?? ""
    }
}
extension EventParticipantsController : EventParticipantsViewDelegate, SignatureRefreshDelegate{
    func didModifySignature(signatureId: Int) {
        interactor.getEventParticipants(completedEvent?.eventID ?? 0, isParticipant: isParticipants)
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
        var identifier = "EventParticipantCellSignAndStarDisabled"
       //EventParticipantCellSignNoStar
        
        print("Has Sign - \(eventParticipant.isSignEnabled) && Has Accesscories - \(eventParticipant.hasAccessories)")
        if eventParticipant.isSignAndStarEnabled{
            identifier = "EventParticipantCell"
        }else if eventParticipant.isSignEnabled && eventParticipant.hasAccessories == false{
          //
            identifier = "EventParticipantCellSignNoStar"
        }else if eventParticipant.hasAccessories{
            identifier = "EventParticipantCellSignDisabled"
        }
        print("Identifier - \(identifier)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventParticipantV2",
                                                 for: indexPath) as! EventParticipantCellV2
        cell.eventParticipant = eventParticipant
        cell.delegate = self
        
        cell.btnDeleteEvent.tag = indexPath.row
        cell.btnDeleteEvent.addTarget(self, action: #selector(deleteEvent), for: .touchUpInside)
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
    
    @objc func deleteEvent(_ sender: UIButton){
        self.ext.confirmationAlert(title: "Alert!", message: "Are you sure you want to cancel this Rider Order", btnText: "YES", btnDismiss: "NO", handler: {
            let eventParticipant = self.participants[sender.tag]
            self.interactor.deleteEventParticipants(EventParticipantData: eventParticipant)
        })
    }
    
    ///Protocol
    func cancelEvent() {

        let alert = UIAlertController(title: "Successful!", message: "Your order has been cancelled successfully", preferredStyle: .alert)
                // Create the actions
        let cancelAction = UIAlertAction(title: "OK", style:
            UIAlertAction.Style.cancel) {
               UIAlertAction in
            self.navigationController?.popViewController(animated: true)
            }
        // Add the actions
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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

extension EventParticipantsController: EventParticipantV2Delegate{
    func clickedOnMotoIcon(_ cell: EventParticipantCellV2, participant: EventParticipant?) {
        showEnrolledClasses(eventParticiapnt: participant!)
    }
    
    func clickedOnSignature(_ cell: EventParticipantCellV2, participant: EventParticipant?) {
        Log.i("Signature Tap identified")
        
        if participant?.signature ?? false{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignaturePreviewViewController") as! SignaturePreviewViewController
            controller.signatureId = participant?.signatureID ?? 0
            navigationController?.pushViewController(controller, animated: true)
        }else{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignatureReader") as! SignatureReaderController
            controller.eventparticipant = participant
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func clickedOnUpgradeSkill(_ cell: EventParticipantCellV2, participant: EventParticipant?) {
        var skills = AppEngine.sharedInstance.generalSkills
        if(skills.count == 0){
            skills = AppConstants.SkillLevels
        }
        self.presentSelectionMenu(title: "Upgrade Skill Level", data: skills){
            selectedItems in
            
            if let skill = selectedItems.first{
                self.interactor.upgradeSkill(skill: skill, userID: participant!.userID ?? 0)
            }
        }
    }
    
    func clickedOnAccessories(_ cell: EventParticipantCellV2, participant: EventParticipant?) {
        Log.i("Training Tap identified")
        //self.interactor.onAccessoriesClicked(participant: participant!)
        
        showListAlert(eventParticiapnt: participant!)
        
        //showEnrolledClasses(eventParticiapnt: participant!)
        
    }
     func showEnrolledClasses(eventParticiapnt: EventParticipant){
        let alertService = AlertService()
         let alertVC = alertService.createListAlertController(title: "Classes", buttonTitle: "OK")
         
         let alertData = AlertListData()
        
         
         if let motoClasses = eventParticiapnt.motoClasses{
            
            alertData.sectionedData = [SectionedKeyValue]()
            alertData.sectionHeaderEnabled = true
             for itemClass in motoClasses{
                 //alertData.simpleItems?.append(itemClass)
                let sectionedKeyValue = SectionedKeyValue()
                sectionedKeyValue.sectionTitle = itemClass.raceName?.capitalized ?? ""
                for race in itemClass.raceClasses!{
                    let keyValue = AlertKeyValue()
                    keyValue.key = race.className ?? ""
                    keyValue.value = race.bikeData?.capitalized ?? ""
                    sectionedKeyValue.data.append(keyValue)
                }
                alertData.sectionedData.append(sectionedKeyValue)
             }
         }
         alertVC.alertDataList = alertData
         present(alertVC, animated: true)
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
