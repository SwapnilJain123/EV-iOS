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
    
    @IBOutlet weak var btnAddToCart: UIButton!
    
    var eventSlug : String = ""
    var eventTitle : String = ""
    var isMotoEvent : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ext.showBackButton()
        btnAddToCart.applyColorTheme()
        eventDetailsView.dataSource = self
        
        let interactor = EventsInteractor()
        interactor.eventDetailsDelegate = self
        interactor.fetchEventDetails(slug: eventSlug, isMotoEvent: isMotoEvent)
    }
    
    override func getScreenTitle() -> String? {
        eventTitle
    }
    
    @IBAction func didPressAddToCart(_ sender: Any) {
    }
    
}

extension EventDetailsController: EventDetailsDelegate{
    func didFetchEventDetails(_ eventDetails: EventDetails, sections: [EventsInteractor.EventDetailsSections]) {
        self.sections = sections
        self.eventDetails = eventDetails
        
        self.eventDetailsView.reloadData()
    }
    
}
extension EventDetailsController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.sections[section] == .rentals{
            return eventDetails?.rentalData?.count ?? 0
        }else if self.sections[section] == .trainings{
            return eventDetails?.trainingData?.count ?? 0
        }else{
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
        }
        return UITableViewCell()
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        sections.count
    }
    
}
