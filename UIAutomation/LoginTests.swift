//
//  LoginTests.swift
//  UITests
//
//  Created by Subair Ariyil on 19/07/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import XCTest

class T2LoginUITest: BaseUITests {
    
    func testT2S1InvalidEmail(){
         app.launch()
        
        app.buttons["ev logo"].tap()
        app.buttons["SIGN IN"].tap()
        
        let loginErrorAlert = app.alerts["Login Error"]
        XCTAssertTrue(loginErrorAlert.exists)
        
        let okButton = loginErrorAlert.scrollViews.otherElements.buttons["OK"]
        okButton.tap()
        
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("tester")
        hideKeyboard()
        app.buttons["SIGN IN"].tap()
        
        XCTAssertTrue(loginErrorAlert.exists)
        okButton.tap()
        
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("tester@gmail.com")
        hideKeyboard()
        app.buttons["SIGN IN"].tap()
        XCTAssertTrue(loginErrorAlert.exists)
        okButton.tap()
        
        
    }
    
    func testT2S2ValidCredentials(){
        let testData = ["user_terms_agreed" : "true"]
        app.launchEnvironment = testData
        app.launch()
        
        app.buttons["ev logo"].tap()
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("uitester@gmail.com")
        hideKeyboard()
        
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("password@123")
        hideKeyboard()
        app.buttons["SIGN IN"].tap()
               
        let dashboard = app.staticTexts["Dashboard"]
        waitForElementToAppear(element: dashboard)
        XCTAssertTrue(dashboard.exists)
                      
    }
}
