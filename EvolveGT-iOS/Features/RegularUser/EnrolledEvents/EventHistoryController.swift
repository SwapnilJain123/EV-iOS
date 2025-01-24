//
//  EventHistoryController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/21.
//  Copyright © 2021 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class EventHistoryController : ETViewController, EnrolledEventsViewDelegate, UITableViewDataSource{
    
    static let TAB_UPCOMING = 0
    static let TAB_PAST = 1
    static let TAB_ALL_EVENTS = 2
    
    var selectedIndex = EventHistoryController.TAB_UPCOMING
    
    @IBOutlet weak var eventTabs: UISegmentedControl!
   
    @IBOutlet weak var eventHistoryTableView: UITableView!
    
    var allEvents =  [EnrolledEvent]()
    var pastEvents =  [EnrolledEvent]()
    var upComingEvents =  [EnrolledEvent]()
    var interactor = EnrolledEventsInteractor()

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()

    }
    
    override func getScreenTitle() -> String? {
        "Event History"
    }
    
    func initViewController(){
        eventHistoryTableView.dataSource = self
        eventHistoryTableView.delegate = self

        eventHistoryTableView.rowHeight = UITableView.automaticDimension
        eventHistoryTableView.estimatedRowHeight = 120
        eventHistoryTableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 220, right: 0)
        
        interactor.delegate = self
        interactor.enrolledEventsDelegate = self
        interactor.fetchEventHistory()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ext.showNavbar()
        interactor.fetchEventHistory()

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillDisappear(animated)
        self.ext.hideNavbar()
    }
    
    @IBAction func didChangeTabs(_ sender: UISegmentedControl) {
        
        selectedIndex = eventTabs.selectedSegmentIndex
        reloadCurrentIndex()
    }
    
    func didFetchAllEvents(events: [EnrolledEvent]) {
        self.allEvents = events
    }
    
    func didFetchPastEvents(events: [EnrolledEvent]?) {
        if let pastEvents = events{
            self.pastEvents = pastEvents
        }
    }
    
    func didFetchUpcomingEvents(events: [EnrolledEvent]?) {
        if let upComingEvents = events{
            self.upComingEvents = upComingEvents
        }
    }
    
    func eventsEmpty() {
        
    }
    
    func reloadCurrentIndex() {
        eventTabs.selectedSegmentIndex = selectedIndex
       
        
        var isEmpty = false
        switch eventTabs.selectedSegmentIndex {
        case EventHistoryController.TAB_UPCOMING:
            isEmpty = upComingEvents.count == 0
        case EventHistoryController.TAB_PAST:
            isEmpty = pastEvents.count == 0
        case EventHistoryController.TAB_ALL_EVENTS:
            isEmpty = allEvents.count == 0
        default:
            isEmpty = true
        }
        
        if isEmpty{
            eventHistoryTableView.setEmptyMessage("Sorry, no event has been found.")
        }else{
            eventHistoryTableView.restore()
        }
        
        eventHistoryTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        switch eventTabs.selectedSegmentIndex {
        case EventHistoryController.TAB_UPCOMING:
            count = upComingEvents.count
        case EventHistoryController.TAB_PAST:
            count = pastEvents.count
        case EventHistoryController.TAB_ALL_EVENTS:
            count = allEvents.count
        default:
            count = 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isUpcoming = eventTabs.selectedSegmentIndex == EventHistoryController.TAB_UPCOMING
        let event = getEnrolledEvent(indexPath: indexPath)
        let id = isUpcoming ? "UpcomingEventCell" : "UpcomingEventCellNoPassport"
        let eventCell = tableView.dequeueReusableCell(withIdentifier:id,for: indexPath) as! EnrolledEventCell
        eventCell.populateViews(event: event, isUpComing: isUpcoming)
        eventCell.delegate = self
        return eventCell
    }
    
    func getEnrolledEvent(indexPath: IndexPath) -> EnrolledEvent{
        var event = EnrolledEvent()
        switch eventTabs.selectedSegmentIndex {
        case EventHistoryController.TAB_UPCOMING:
            event = upComingEvents[indexPath.row]
        case EventHistoryController.TAB_PAST:
            event = pastEvents[indexPath.row]
        case EventHistoryController.TAB_ALL_EVENTS:
            event = allEvents[indexPath.row]
        default:
            event = EnrolledEvent()
        }
        return event
    }
}

extension EventHistoryController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let event = getEnrolledEvent(indexPath: indexPath)
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in

            var children = [UIAction]()
            
            var image = UIImage(named: "star") as UIImage?
            if !AppEngine.sharedInstance.isEvApp(){
                image = UIImage(named: "admin_moto_star") as UIImage?
            }
            
            let accessories = UIAction(title: "Accessories", image: image) { action in
                self.showAccessories(event: event)
            }
            
            let iamhere = UIAction(title: "I Am Here", image: nil) { action in
                self.uploadPassport(event: event)
            }
            
            let cancel = UIAction(title: "Cancel", image: nil) { action in
                self.cancelEvent(event: event)
            }
            cancel.attributes.insert(.destructive)
            
            if event.hasAccessories{
                children.append(accessories)
            }
            if(event.enableSelfsign ?? false) && !(event.hasPassport ?? false){
                //children.append(iamhere)
                if(!event.canUploadPassport){
                   // iamhere.attributes.insert(.disabled)
                }
            }
            if AppEngine.sharedInstance.canCancelEvent{
                children.append(cancel)
            }
            if self.eventTabs.selectedSegmentIndex == EventHistoryController.TAB_UPCOMING{
                return UIMenu(title: "", children: children)
            }else{
                return nil
            }
        }
    }
    
    
  
}

extension EventHistoryController: EnrolledEventCellDelegate{
    
    func cancelEvent(event: EnrolledEvent) {
        self.ext.confirmationAlert(title: "Cancel Event", message: "You are about to cancel the event - \(event.productName ?? ""). Do you really want to proceed?", btnText: "Yes", btnDismiss: "No"){
            let interactor = EnrolledEventsInteractor()
            interactor.delegate = self
            interactor.cancelEvent(itemID: event.orderItemID ?? 0)
        }
    }
    
    func showPassport(event: EnrolledEvent) {
        AppEngine.sharedInstance.passportId = event.passportId ?? 0
        AppEngine.sharedInstance.trackName = event.productName ?? "0"
        AppEngine.sharedInstance.eventDate = event.eventDate ?? ""
        self.ext.pushViewController(storyBoard: "EnrolledEvents", VCIdentifier: ShowPassportController.identifier)
    }
    
    func uploadPassport(event: EnrolledEvent){
        AppEngine.sharedInstance.passportId = event.passportId ?? 0
        AppEngine.sharedInstance.eventId = event.eventId ?? 0
        self.ext.pushViewController(storyBoard: "EnrolledEvents", VCIdentifier: UploadPassportController.identifier)
    }
    
    func showAccessories(event: EnrolledEvent) {
        if(AppEngine.sharedInstance.isEvApp()){
            showEvAccessories(event: event)
        }else{
            showMotoAccessories(event: event)
        }
    }
    
    override func showSuccessToastMessage(message: String) {
        super.showSuccessToastMessage(message: message)
        interactor.fetchEventHistory()
        
    }
    
    func showMotoAccessories(event: EnrolledEvent){
       let alertService = AlertService()
        let alertVC = alertService.createListAlertController(title: "Classes", buttonTitle: "OK")
        
        let alertData = AlertListData()
       
        
        if let motoClasses = event.motoClasses{
           
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
   func showEvAccessories(event: EnrolledEvent){
   
       let alertService = AlertService()
       let alertVC = alertService.createListAlertController(title: "Accessories", buttonTitle: "OK")
       
       Log.d("Training Count \(event.trainings?.count ?? 0)")
       Log.d("Rental Count \(event.rentals?.count ?? 0)")
       
       let alertData = AlertListData()
      
       
       if let trainings = event.trainings{
          
           alertData.simpleItemsTitle = "Trainings"
           alertData.simpleItems = [String]()
           for training in trainings{
               alertData.simpleItems?.append(training)
           }
       }
       
       if let rentals = event.rentals{
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
