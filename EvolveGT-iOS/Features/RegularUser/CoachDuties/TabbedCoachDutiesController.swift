//
//  TabbedCoachDutiesController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip


class TabbedCoachDutiesController :ButtonBarPagerTabStripViewController{
    
    var assignedEvents =  [AssignedEvent]()
    override func viewDidLoad() {
        
        let appColor = UIColor.getAppThemeColor()
        settings.style.buttonBarBackgroundColor = appColor
        settings.style.buttonBarItemBackgroundColor = appColor
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 15)
        settings.style.selectedBarHeight = 4.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?,
            progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = .darkGray
            newCell?.label.textColor = .white
            
        }
        
         
        super.viewDidLoad()
        self.title = getScreenTitle()
    }
    
    func getScreenTitle() -> String{
        ScreenTitle.TITLE_COACH_DUTIES
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = getScreenTitle()
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController]{
        var controllers = [CoachDutiesController]()
        
       
        for event in assignedEvents{
            let coachDutyController = self.ext.getViewController(storyBoard: "CoachDuties", VCIdentifier: "CoachDutiesVC") as! CoachDutiesController
            coachDutyController.assignedEvent = event
           
            controllers.append(coachDutyController)
        }
        
        
        return controllers
    }
}

