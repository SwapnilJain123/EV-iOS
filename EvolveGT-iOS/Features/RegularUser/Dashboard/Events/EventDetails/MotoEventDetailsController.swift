//
//  MotoEventDetailsController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 18/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class MotoEventController : ETViewController{
    
    var eventDetails : EventDetails?
    
    @IBOutlet weak var motoDetailsView: UITableView!
    
    var sections : [EventsInteractor.MotoSections] = [EventsInteractor.MotoSections]()
    let interactor = EventsInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = interactor.getMotoSections(eventDetails)
        motoDetailsView.dataSource = self
        motoDetailsView.delegate = self
    }
    
    override func getScreenTitle() -> String? {
        eventDetails?.title ?? "Event Details"
    }
}
extension MotoEventController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .eventClasses:
            return eventDetails?.activeEventClasses.count ?? 0
        case .skillSelection:
            return 1
        case .trackDays:
            return 1
        case .transponder:
            return 1
       
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.sections[indexPath.section] == .eventClasses{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventClassCell", for: indexPath as IndexPath) as! EventClassCell
            cell.showData(eventClass: eventDetails!.eventClasses![indexPath.row], indexPath: indexPath)
            return cell
        }else if self.sections[indexPath.section] == .skillSelection{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkillLevelCell", for: indexPath as IndexPath) as! SkillLevelCell
            cell.showData(amateur: eventDetails!.skillSet![0], expert: eventDetails!.skillSet![1], hasSkillRegistered: eventDetails?.hasSkillRegistered ?? false)
            return cell
        } else{
            return UITableViewCell()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
           section: Int) -> String? {
           if sections[section] == .eventClasses{
               return " Select Class"
           }else if sections[section] == .skillSelection{
               return " Select Your Skill Level"
           }else{
               return ""
           }
           
       }
    
}
