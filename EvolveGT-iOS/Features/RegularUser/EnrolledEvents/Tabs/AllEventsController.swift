//
//  AllEventsController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 09/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
class AllEventsController : ETViewController, SlidingTabDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var eventsTableView: UITableView!
    var events : [EnrolledEvent]?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         Log.d("Event Count :\(events?.count ?? 0)")
        reloadPage()
    }
    
    func reloadPage() {
         eventsTableView?.reloadData()
               
              if events?.count ?? 0 == 0{
                   self.ext.displayEmptyMessage(message: ErrorMessages.emptyEnrolledEvents)
               }else{
                   self.ext.hideErrorView()
               }
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        
        eventsTableView.dataSource = self
        eventsTableView.rowHeight = UITableView.automaticDimension
        eventsTableView.estimatedRowHeight = 120
        eventsTableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 220, right: 0)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         let count = events?.count ?? 0
              
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCell = tableView.dequeueReusableCell(withIdentifier:"AllEventCell",for: indexPath) as! EnrolledEventCell
        
        eventCell.populateViews(event: events![indexPath.row])
        
        return eventCell
    }
}
