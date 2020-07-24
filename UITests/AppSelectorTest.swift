//
//  AppSelectorTest.swift
//  UITests
//
//  Created by Subair Ariyil on 19/07/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import XCTest
class AppSelectorTest: BaseUITests {
    
    func testAppSelection(){
        let notificationAlert = app.alerts["“Evolve GT” Would Like to Send You Notifications"]
        if notificationAlert.exists{
            notificationAlert.scrollViews.otherElements.buttons["Allow"].tap()
        }
        
        XCTAssertTrue(app.buttons["ev logo"].exists)
        XCTAssertTrue(app.buttons["moto logo"].exists)
        
        
        
    }
    
    func testSelectEvMode(){
        
        app.buttons["ev logo"].tap()
        
        //Login Screen Launched
        XCTAssertTrue(app.buttons["SIGN IN"].exists)
        
    }
    func testSelectMotoMode(){
        
        app.buttons["moto logo"].tap()
        
        //Login Screen Launched
        XCTAssertTrue(app.buttons["SIGN IN"].exists)
        
    }
}
