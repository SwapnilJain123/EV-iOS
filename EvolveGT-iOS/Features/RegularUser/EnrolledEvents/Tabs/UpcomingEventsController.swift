//
//  UpcomingEventsController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 09/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip
class UpcomingEventsController : ETViewController, TabProtocol, UITableViewDataSource{
    
    
    
    @IBOutlet weak var eventsTableView: UITableView!
    var events : [EnrolledEvent]?
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: ScreenTitle.TITLE_UPCOMING_EVENTS.uppercased())
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        eventsTableView.dataSource = self
        eventsTableView.rowHeight = UITableView.automaticDimension
        eventsTableView.estimatedRowHeight = 120
    }
    
    func reload() {
        eventsTableView.reloadData()
        
        if events == nil{
            eventsTableView.isHidden = true
            self.ext.displayEmptyMessage(message: ErrorMessages.emptyEnrolledEvents)
        }else{
            eventsTableView.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = events?.count ?? 0
        eventsTableView.setEmptyBackground(rowCount: count, message: ErrorMessages.emptyEnrolledEvents)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCell = tableView.dequeueReusableCell(withIdentifier:"UpcomingEventCell",for: indexPath) as! EnrolledEventCell
        
        eventCell.populateViews(event: events![indexPath.row])
        eventCell.delegate = self
        return eventCell
    }
}
extension UpcomingEventsController: EnrolledEventCellDelegate{
    
    func cancelEvent(event: EnrolledEvent) {
        self.ext.confirmationAlert(title: "Cancel Event", message: "You are about to cancel the event - \(event.productName ?? ""). Do you really want to proceed?", btnText: "Yes", btnDismiss: "No"){
            let interactor = EnrolledEventsInteractor()
            interactor.delegate = self
            interactor.cancelEvent(itemID: event.orderItemID ?? "")
        }
    }
    
    override func showSuccessToastMessage(message: String) {
        super.showSuccessToastMessage(message: message)
        (self.parent as! EnrolledEventsTabController).fetchEventHistory()
    }
}
