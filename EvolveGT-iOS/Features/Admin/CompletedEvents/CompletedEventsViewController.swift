//
//  CompletedEventsViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit


class CompletedEventViewController : ETViewController{
    
    @IBOutlet weak var eventsTableView: UITableView!
    var interactor = CompletedEventsInteractor()
    var completedEvents = [CompletedEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        
        interactor.delegate = self
        interactor.viewDidLoad()
    }
}

extension CompletedEventViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Admin", bundle: nil)
        let eventParticipantsController = storyBoard.instantiateViewController(withIdentifier: "EventParticipants") as! EventParticipantsController
        eventParticipantsController.completedEvent = completedEvents[indexPath.row]
        self.navigationController?.pushViewController(eventParticipantsController, animated: true)
    }
}
extension CompletedEventViewController : UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Log.d("Size = \(completedEvents.count)")
        return completedEvents.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedEvent", for: indexPath) as! CompletedEventCell
        cell.showData(completdEvent: completedEvents[indexPath.row])
        return cell
    }
    
    
}

extension CompletedEventViewController: CompletedEventsViewDelegate{
    func didFetchCompletedEvents(events: [CompletedEvent]) {
        completedEvents.removeAll()
        completedEvents.append(contentsOf: events)
        eventsTableView.reloadData()
    }
    
    func showProgressIndicator(message: String?) {
        self.addLoadingIndicator()
    }
    
    func hideProgressIndicator() {
        self.removeLoadingIndicator()
    }
    
    func showError(message: String) {
        self.showAlert(title: "Api Error", message: "Events not found")
    }
    
    
}
