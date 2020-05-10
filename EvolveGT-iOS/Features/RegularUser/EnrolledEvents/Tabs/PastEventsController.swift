//
//  PastEventsController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 09/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip
class PastEventsController : ETViewController, TabProtocol, UITableViewDataSource{
    
    @IBOutlet weak var eventsTableView: UITableView!
    var events : [EnrolledEvent]?
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: ScreenTitle.TITLE_PAST_EVENTS.uppercased())
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
            self.ext.displayEmptyMessage(message: ErrorMessages.emptyEnrolledEvents)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = events?.count ?? 0
        eventsTableView.setEmptyBackground(rowCount: count, message: ErrorMessages.emptyEnrolledEvents)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCell = tableView.dequeueReusableCell(withIdentifier:"PastEventCell",for: indexPath) as! EnrolledEventCell
        
        eventCell.populateViews(event: events![indexPath.row])
        
        return eventCell;
    }
}
