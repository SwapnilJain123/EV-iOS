//
//  EventDetailsController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 15/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
class EventDetailsController : ETViewController{
    
    @IBOutlet weak var eventDetailsView: UITableView!
    
    var eventDetails : EventDetails? = nil
    var sections = [EventsInteractor.EventDetailsSections]()
    let interactor = EventsInteractor()
    @IBOutlet weak var btnAddToCart: UIButton!
    
    var eventSlug : String = ""
    var eventTitle : String = ""
    var isMotoEvent : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ext.showBackButton()
        
        
        eventDetailsView.rowHeight = UITableView.automaticDimension
        eventDetailsView.dataSource = self
        eventDetailsView.delegate = self
        
        eventDetails?.slug = self.eventSlug
        
        interactor.eventDetailsDelegate = self
        
    }
    
    override func getScreenTitle() -> String? {
        eventTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.fetchEventDetails(slug: eventSlug, isMotoEvent: isMotoEvent)
        btnAddToCart.applyColorTheme()
        
    }
    @IBAction func didPressAddToCart(_ sender: Any) {
        
        if !AppEngine.sharedInstance.isUserLoggedIn(){
            self.ext.confirmationAlert(title: AlertTitle.loginRequired, message: MessageConstants.loginRequired, btnText: "Login"){
                self.dashboardManager.switchToLoginPage()
                return
            }
        }else{
            eventDetails?.slug = self.eventSlug
            if eventDetails?.external != nil{
                self.ext.confirmationAlert(title: AlertTitle.externalHost, message: MessageConstants.externalLink, btnText: "Open"){
                    self.ext.openLink(self.eventDetails!.external!.url!)
                    return
                }
            }else if (eventDetails?.isPrivateEvent ?? false) {
                //Mark: get the private code
                addPrivateEventToCart(eventDetails!)
            }else  if isMotoEvent{
                addMotoEventToCart()
                
            }else{
                interactor.addEvolveEventToCart(eventDetails!)
            }
        }
    }
    
    func addMotoEventToCart(){
        if !AppEngine.sharedInstance.isUserLoggedIn() {
            //Mark: Login required
        }else {
            if !(eventDetails?.hasRaceLicense ?? false){
                
                self.ext.showAlertWithAttributedText(title: AlertTitle.raceLicenceRequired, text: MessageConstants.txtRaceLicenceRequired.toAttributedText(with: 15.0)!, action: nil)
            }else if !(eventDetails?.skillEligible ?? false){
                self.ext.showAlert(title: AlertTitle.skillNotEligible, message: ErrorMessages.skillNotEligibleMessage)
                
            }else{
                interactor.addMotoEventToCart(eventDetails!)
            }
        }
    }
    func addPrivateEventToCart(_ event: EventDetails){
        
        let alert = UIAlertController(title: "Enter your secret code", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Secret Code"
        })
        
        alert.addAction(UIAlertAction(title: "Add To Cart", style: .default, handler: { action in
            
            if let secretCode = alert.textFields?.first?.text {
                event.couponCode = secretCode
                self.interactor.addEvolveEventToCart(event)
            }
        }))
        
        self.navigationController?.present(alert, animated: true)
        
    }
    
    func addPrivateEventToCart(_ event: Event){
        var selectedEvent = event
        let alert = UIAlertController(title: "Enter your secret code", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Secret Code"
        })
        
        alert.addAction(UIAlertAction(title: "Add To Cart", style: .default, handler: { action in
            
            if let secretCode = alert.textFields?.first?.text {
                selectedEvent.couponCode = secretCode
                self.interactor.addEventToCart(selectedEvent)
            }
        }))
        
        self.navigationController?.present(alert, animated: true)
    }
    
}

extension EventDetailsController: EventDetailsDelegate{
    func validationError(_ errorMessage: String) {
        self.ext.showAlert(title: nil, message: errorMessage)
    }
    
    func didFetchEventDetails(_ eventDetails: EventDetails, sections: [EventsInteractor.EventDetailsSections]) {
        
        self.sections = sections
        self.eventDetails = eventDetails
        self.eventDetails?.isMotoEvent = isMotoEvent
        
        self.eventDetailsView.reloadData()
    }
    
}
extension EventDetailsController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch sections[section] {
        case .eventClasses:
            return eventDetails?.activeEventClasses.count ?? 0
        case .skillSelection:
            return 1
        case .trackDays:
            return eventDetails?.trackDays?.count ?? 0
        case .transponder:
            return 1
        case .basic:
            return 1
        case .rentals:
            return eventDetails?.rentalData?.count ?? 0
        case .trainings:
            return eventDetails?.trainingData?.count ?? 0
        case .about:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.sections[indexPath.section] == .basic{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventInfoCell", for: indexPath as IndexPath) as! EventInfoCell
            cell.showData(eventDetails: eventDetails!)
            return cell
        }else if self.sections[indexPath.section] == .about{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutEvent", for: indexPath as IndexPath) as! AboutEventCell
            cell.showData(eventDetails: eventDetails)
            return cell
        }else if self.sections[indexPath.section] == .trainings{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrainingItem", for: indexPath as IndexPath) as! TrainingItemCell
            cell.training = eventDetails!.trainingData![indexPath.row]
            cell.delegate = self
            return cell
        } else if self.sections[indexPath.section] == .rentals{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RentalItem", for: indexPath as IndexPath) as! RentItemCell
            cell.delegate = self
            cell.showData(rentalItem: eventDetails!.rentalData![indexPath.row], indexPath: indexPath)
            return cell
        }else if self.sections[indexPath.section] == .eventClasses{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventClassCell", for: indexPath as IndexPath) as! EventClassCell
            cell.showData(eventClass: eventDetails!.activeEventClasses[indexPath.row], indexPath: indexPath)
            cell.delegate = self
            return cell
        }else if self.sections[indexPath.section] == .skillSelection{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkillLevelCell", for: indexPath as IndexPath) as! SkillLevelCell
            cell.showData(amateur: eventDetails!.skillSet![0], expert: eventDetails!.skillSet![1], hasSkillRegistered: eventDetails?.hasSkillRegistered ?? false)
            cell.delegate = self
            return cell
        } else if self.sections[indexPath.section] == .transponder{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransponderCell", for: indexPath as IndexPath) as! TransponderCell
            cell.showData(transponder: eventDetails!.transponder!, indexPath: indexPath)
            cell.delegate = self
            return cell
        }else if self.sections[indexPath.section] == .trackDays{
            let cell = tableView.dequeueReusableCell(withIdentifier: TrackDayCell.identifier, for: indexPath as IndexPath) as! TrackDayCell
            cell.trackDay = eventDetails?.trackDays![indexPath.row]
            cell.delegate = self
            return cell
        }
        
        
        return UITableViewCell()
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        sections.count
    }
    
    //section header for rentals and trainings
    func tableView(_ tableView: UITableView, titleForHeaderInSection
        section: Int) -> String? {
        if sections[section] == .trainings{
            return " Select Trainings"
        }else if sections[section] == .rentals{
            return " Select Rentals"
        }else  if sections[section] == .eventClasses{
            return " Select Class"
        }else if sections[section] == .skillSelection{
            return " Select Your Skill Level"
        }else if sections[section] == .transponder{
            return " Transponder"
        }else if sections[section] == .trackDays{
            return " Want to purchase the track day for this date?"
        }else {
            return ""
        }
        
    }
}
extension EventDetailsController: TrainingDelegate, RentalDelegate, EventClassCellDelegate, SkillLevelCellDelegate, TransponderCellDelegate, TrackDayCellDelegate{
    func didPressAddToCart(event: Event) {
        if(event.isPrivateEvent ?? false){
            addPrivateEventToCart(event)
        }else if(event.external != nil){
            self.ext.confirmationAlert(title: AlertTitle.externalHost, message: MessageConstants.externalLink, btnText: "Open"){
                self.ext.openLink(event.external!.url ?? "")
                return
            }
        }else{
            interactor.addEventToCart(event)
        }
    }
    
    func didChangeEventClassSelection(eventClass: EventClass, indexPath: IndexPath, checkedStatus: Bool) {
        eventClass.isSelected = checkedStatus
        var paths = [IndexPath]()
        paths.append(IndexPath(row: 0, section: 0))
        paths.append(indexPath)
        self.eventDetailsView.reloadRows(at: paths, with: .none)
    }
    
    func didChangeSkillSet(skill: String) {
        eventDetails?.selectedSkill = skill
    }
    
    func didSelectTransponderForRent(transponder: Transponder, indexPath: IndexPath, _ checked: Bool) {
        transponder.isSelected = checked
        var paths = [IndexPath]()
        paths.append(IndexPath(row: 0, section: 0))
        paths.append(indexPath)
        
        self.eventDetailsView.reloadRows(at: paths, with: .none)
    }
    
    func didEnterTransponderNumber(transponderNumber: String, transponder: Transponder, indexPath: IndexPath) {
        transponder.number = transponderNumber
        self.eventDetailsView.reloadRows(at: [indexPath], with: .none)
        
    }
    
    func didChangeTrainingSelection(training: TrainingDatum, checkedStatus: Bool) {
        if let selectedTraining = eventDetails?.trainingData?.first(where:{$0.title == training.title}){
            selectedTraining.isSelected = checkedStatus
            let indexPath = IndexPath(row: 0, section: 0)
            eventDetailsView.reloadRows(at: [indexPath], with: .none)
        }
    }
    func didChangeRentalSelection(rental: RentalDatum, indexPath: IndexPath, checkedStatus: Bool) {
        if checkedStatus{
            self.ext.presentOptions(title: "Variations of \(rental.title ?? "Select")", message: "Select a \(rental.variations?.first?.attributeName ?? "Option")", options: rental.variantOptions, selected: nil){ selected in
                Log.d("Selected : \(selected)")
                rental.selectedVariant = rental.findVariantByValue(value: selected)
                
                var paths = [IndexPath]()
                paths.append(IndexPath(row: 0, section: 0))
                paths.append(indexPath)
                
                self.eventDetailsView.reloadRows(at: paths, with: .none)
            }
        }else{
            rental.selectedVariant = nil
            var paths = [IndexPath]()
            paths.append(IndexPath(row: 0, section: 0))
            paths.append(indexPath)
            
            self.eventDetailsView.reloadRows(at: paths, with: .none)
        }
        
        handleOutOfStock()
        
    }
    func handleOutOfStock(){
        if eventDetails?.isOutofStock ?? false{
            btnAddToCart.setTitle("Out Of Stock", for: .disabled)
            btnAddToCart.isEnabled = false
        }else{
            btnAddToCart.isEnabled = true
        }
    }
    
}
