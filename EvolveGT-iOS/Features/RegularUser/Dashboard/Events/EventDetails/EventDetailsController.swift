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
        eventDetailsView.sectionHeaderHeight = UITableView.automaticDimension
        eventDetailsView.estimatedSectionHeaderHeight = 0
        
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
        self.eventDetails = self.interactor.eventDetails
        if !AppEngine.sharedInstance.isUserLoggedIn() {
            //Mark: Login required
        }else {
            interactor.addMotoEventToCart(eventDetails!)
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
    func registrationDenied(title: String, message: String) {
        self.ext.showAlert(title: title, message: message, handler: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func mrlLicenceRequired(eventDetails: EventDetails) {
        self.ext.showAlertWithAttributedText(title: "MRL Licence Required", text: eventDetails.mrlHTML!.toAttributedText(with: 17.0)!, action: {
            self.navigationController?.popViewController(animated: true)

        })
    }
    
    func validationError(_ errorMessage: String) {
        //self.ext.showAlert(title: nil, message: errorMessage)
        self.ext.showErrorToast(message: errorMessage, handler: nil)
    }
    
    func didFetchEventDetails(_ eventDetails: EventDetails, sections: [EventsInteractor.EventDetailsSections]) {
        
        if sections.count > 0{
            self.sections = sections
        }
        self.eventDetails = eventDetails
        self.eventDetails?.isMotoEvent = isMotoEvent
        
        self.eventDetailsView.reloadData()
    }
    
    func addEventToCalendar(event: EventDetails) {
           self.ext.confirmationAlert(title: "Add Event To Calendar", message: SuccessMessages.eventConfirmation, btnText: "Add Event", handler: {
               self.ext.addEventToCalendar(title: event.title!, description: "\(event.eventType ?? "") event", startDate: event.eventDate!.createDate(inPattern: .FORMAT_YYYY_MM_DD_HIPHEN).addingTimeInterval(TimeInterval(6 * 60.0 * 60.0)), endDate: event.eventDate!.createDate(inPattern: .FORMAT_YYYY_MM_DD_HIPHEN).addingTimeInterval(TimeInterval(10 * 60.0 * 60.0))){ added, error in
                   
                   DispatchQueue.main.async() {
                        self.showSuccessToastMessage(message: SuccessMessages.eventAddedToCalendar)
                   }
               }
           })
       }
    
}
extension EventDetailsController: UITableViewDataSource, UITableViewDelegate{
   
    func numberOfSections(in tableView: UITableView) -> Int{
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch sections[section] {
        case .eventClasses:
            let raceCount = eventDetails?.eventClasses![section - 1].raceClasses?.count ?? 0
            return raceCount > 0 ? (raceCount + 1) : 0
            //return eventDetails?.activeEventClasses.count ?? 0
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
        case .mrlLicence:
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
            cell.radiobutton.tag = indexPath.row
            cell.radiobutton.addTarget(self, action: #selector(actionRadio(_:)), for: .touchUpInside)
            return cell
        } else if self.sections[indexPath.section] == .rentals{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RentalItem", for: indexPath as IndexPath) as! RentItemCell
            cell.delegate = self
            cell.showData(rentalItem: eventDetails!.rentalData![indexPath.row], indexPath: indexPath)
            return cell
        }else if self.sections[indexPath.section] == .eventClasses{
            
            if(indexPath.row == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: EventClassHeader.identifier, for: indexPath as IndexPath) as! EventClassHeader
                cell.setHeader(title: eventDetails!.eventClasses![indexPath.section - 1].raceName ?? "")
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "EventClassCell", for: indexPath as IndexPath) as! EventClassCell
                let eventClass = eventDetails!.eventClasses![indexPath.section - 1]
                let raceClass = eventClass.raceClasses![indexPath.row - 1]
                cell.showData(eventClass: eventClass, raceClass: raceClass, indexPath: indexPath)
                cell.delegate = self
                return cell
            }
        }else if self.sections[indexPath.section] == .skillSelection{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkillLevelCell", for: indexPath as IndexPath) as! SkillLevelCell
            cell.showData(racerStatus: eventDetails?.racerStatus ?? "", skillRegistered: eventDetails?.registeredSkill ?? "")
            cell.delegate = self
            return cell
        } else if self.sections[indexPath.section] == .transponder{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransponderCell", for: indexPath as IndexPath) as! TransponderCell
            cell.showData(transponderNumber: eventDetails?.transponderNo ?? "", bikeNumber: eventDetails?.bikeNo ?? "",  indexPath: indexPath)
            cell.delegate = self
            return cell
        }else if self.sections[indexPath.section] == .trackDays{
            let cell = tableView.dequeueReusableCell(withIdentifier: TrackDayCell.identifier, for: indexPath as IndexPath) as! TrackDayCell
            cell.trackDay = eventDetails?.trackDays![indexPath.row]
            cell.delegate = self
            return cell
        }else if self.sections[indexPath.section] == .mrlLicence{
            let cell = tableView.dequeueReusableCell(withIdentifier: MrlLicenceCell.identifier, for: indexPath as IndexPath) as! MrlLicenceCell
            cell.purchaseHandler = { mrlData in
                self.interactor.addMrlLicenceToCart(mrlData: mrlData)
            }
            cell.updateUi(mrlData: eventDetails!.mrlData!)
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func actionRadio(_ sender: UIButton) {
        for i in 0..<(eventDetails?.trainingData?.count ?? 0) {
            if eventDetails?.trainingData?[i].isSelected == true {
                eventDetails?.trainingData?[i].isSelected = false
            }
        }
        eventDetails?.trainingData?[sender.tag].isSelected = true
        DispatchQueue.main.async {
            self.eventDetailsView.reloadData()
        }
    }
    
    //section header for rentals and trainings
    func tableView(_ tableView: UITableView, titleForHeaderInSection
        section: Int) -> String? {
        if sections[section] == .trainings{
            return " Select Trainings"
        }else if sections[section] == .rentals{
            return " Select Rentals"
        }else  if sections[section] == .eventClasses{
            return ""
        }else if sections[section] == .skillSelection{
            return " Racer Status"
        }else if sections[section] == .transponder{
            return " Transponder and Bike Number"
        }else if sections[section] == .trackDays{
            return " Want to purchase the track day for this date?"
        }else if sections[section] == .mrlLicence{
            return " MRL Licence Required."
        }else {
            return ""
        }
        
    }
    
   
}
extension EventDetailsController: RentalDelegate, EventClassCellDelegate, SkillLevelCellDelegate, TransponderCellDelegate, TrackDayCellDelegate{
    func didEnterBikeNumber(bikeNumber: String, indexPath: IndexPath) {
        self.eventDetails?.bikeNo = bikeNumber
        Log.i("Bike Number No set to \(bikeNumber)")
        self.eventDetailsView.reloadRows(at: [indexPath], with: .none)
    }
    
    
    func didPressAddTrackDayToCart(event: Event) {
        interactor.addTrackDayToCart(event)
    }
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
    
    func didChangeEventClassSelection(eventClass: EventClass, raceClass: EventRaceClass, indexPath: IndexPath, checkedStatus: Bool) {
        raceClass.checked = checkedStatus
       
        if(eventClass.hasSpecialClass() && !(raceClass.specialCase ?? false)){
            eventClass.validateSpecialCase(raceClass);
        }
       
        self.eventDetailsView.reloadSections([0, indexPath.section], with: .none)
    }
    
    func didChangeSkillSet(skill: String) {
        Log.i("Skill set to \(skill)")
        eventDetails?.racerStatus = skill
    }
    
    /*
    func didSelectTransponderForRent(transponder: Transponder, indexPath: IndexPath, _ checked: Bool) {
        transponder.isSelected = checked
        var paths = [IndexPath]()
        paths.append(IndexPath(row: 0, section: 0))
        paths.append(indexPath)
        
        //self.eventDetailsView.reloadRows(at: paths, with: .none)
         self.eventDetailsView.reloadData()
    }
     */
    func didEnterTransponderNumber(transponderNumber: String, indexPath: IndexPath) {
       // transponder.number = transponderNumber
        self.eventDetails?.transponderNo = transponderNumber
        Log.i("Transponder No set to \(transponderNumber)")
        self.eventDetailsView.reloadRows(at: [indexPath], with: .none)
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
