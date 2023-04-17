//
//  CoachDutiesSlidingTabController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 29/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class CoachDutiesSlidingTabController: ETViewController{
    
    var assignedEvents =  AssignedDuty()
    private let slidingTabController = UISimpleSlidingTabController()
    
    
   
    private func setupUI(){
        
        // navigation
        navigationItem.title = getScreenTitle()
        
        view.backgroundColor = .clear
        view.addSubview(slidingTabController.view)
        
        provideViewControllers()
        
        slidingTabController.setHeaderActiveColor(color: .white)
        slidingTabController.setHeaderInActiveColor(color: .lightText)
        slidingTabController.setHeaderBackgroundColor(color: .getAppThemeColor())
        slidingTabController.setCurrentPosition(position: 0)
        slidingTabController.setStyle(style: .flexible)
        slidingTabController.build()
    }
    override func getScreenTitle() -> String{
        ScreenTitle.TITLE_COACH_DUTIES
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = getScreenTitle()
        setupUI()
    }
    private func provideViewControllers() {
        /*
        for event in assignedEvents{
            let coachDutyController = self.ext.getViewController(storyBoard: "CoachDuties", VCIdentifier: "CoachDutiesVC") as! CoachDutiesController
            //coachDutyController.assignedEvent = event
            
            slidingTabController.addItem(item: coachDutyController, title: event.event ?? "")
        }
 */
        
    }
}
