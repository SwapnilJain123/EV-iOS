//
//  AppSelectorTest.swift
//  UITests
//
//  Created by Subair Ariyil on 19/07/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import XCTest
class T1AppSelectorTest: BaseUITests {
    
    func testT1S1AppSelection(){
         app.launch()
        let notificationAlert = app.alerts["“Evolve GT” Would Like to Send You Notifications"]
        if notificationAlert.exists{
            notificationAlert.scrollViews.otherElements.buttons["Allow"].tap()
        }
        
        XCTAssertTrue(app.buttons["ev logo"].exists)
        XCTAssertTrue(app.buttons["moto logo"].exists)
        
        
        
    }
    
    func testT1S2SelectEvMode(){
         app.launch()
        app.buttons["ev logo"].tap()
        
        //Login Screen Launched
        XCTAssertTrue(app.buttons["SIGN IN"].exists)
        
    }
    func testT1S3SelectMotoMode(){
         app.launch()
        app.buttons["moto logo"].tap()
        
        //Login Screen Launched
        XCTAssertTrue(app.buttons["SIGN IN"].exists)
        
    }
}
