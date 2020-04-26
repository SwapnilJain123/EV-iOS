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
class EventParticipantsController : ETViewController{
    
    var completedEvent : CompletedEvent?
    var participants = [EventParticipant]()
    
    @IBOutlet weak var eventSearch: UISearchBar!
    @IBOutlet weak var eventBanner: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var particiapntTable: UITableView!
    
    
    let interactor = EventParticipantIntercator()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.delegate = self
        particiapntTable.delegate = self
        particiapntTable.dataSource = self
        
        self.showBackButton()
        setupUI()
        requestEventParticipants()
    }
    
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_EVENTS_USERS
    }
    
    func requestEventParticipants(){
        interactor.getEventParticipants(completedEvent?.eventID ?? "-1")
    }
    func setupUI(){
        
        eventSearch.showsCancelButton = true
        
        if let url = URL(string: completedEvent?.eventLogo ?? ""){
            let fallbackImage = UIImage(named: "et_fallback_image")
            eventBanner.kf.setImage(with: url,placeholder: fallbackImage,  options: [.transition(ImageTransition.fade(1))])
        }
        eventTitle.text = completedEvent?.title ?? ""
        eventDate.text = completedEvent?.eventDate.formattedDate(outputFormat: .FORMAT_DD_MMM_YYYY) ?? ""
        
        //particiapntTable.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        //particiapntTable.separatorColor = UIColor.darkGray
    }
}
extension EventParticipantsController : EventParticipantsViewDelegate{
    func didFetchParticipants(participants: [EventParticipant]) {
        self.participants.removeAll()
        self.participants.append(contentsOf: participants)
        particiapntTable.reloadData()
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

extension EventParticipantsController : UITableViewDelegate{
    
}

extension EventParticipantsController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.participants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventParticipantCell",
                                                 for: indexPath) as! EventParticipantCell
        //cell.delegate = self
        //cell.indePathForRef = indexPath
        cell.eventParticipant = participants[indexPath.row]
       // cell.contentView.setCardView()
        return cell
    }
    
    
}
