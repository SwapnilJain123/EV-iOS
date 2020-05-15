//
//  EventDetailsController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 15/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class EventDetailsController : ETViewController{
    
    var eventSlug : String = ""
    var eventTitle : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func getScreenTitle() -> String? {
        eventTitle
    }
}
