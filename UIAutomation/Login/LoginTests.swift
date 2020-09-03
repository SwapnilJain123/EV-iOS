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
    
    func test_T2S1_InvalidEmail(){
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
    
    func test_T2S2_ValidCredentials(){
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
    
    func test_T2S3_InvalidEmailinMoto(){
        app.launch()
        
        app.buttons["moto logo"].tap()
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
    
    func test_T2S4_ValidCredentialsInMoto(){
        testData = ["user_terms_agreed" : "true"]
        loginAsRegularUser(isEvApp: false)
        
        let dashboard = app.staticTexts["Dashboard"]
        waitForElementToAppear(element: dashboard)
        XCTAssertTrue(dashboard.exists)
        
    }
    
    func test_T2S5_ContinueGuestInEv(){
        testData = ["user_terms_agreed" : "true"]
        app.launchEnvironment = testData
        app.launch()
        
        app.buttons["ev logo"].tap()
        let loginPage = app.buttons["SIGN IN"]
        waitForElementToAppear(element: loginPage)
        
        let guestButton = app.buttons["Continue as a Guest"]
        XCTAssertTrue(guestButton.exists)
        
    }
    func test_T2S6_ContinueGuestInMoto(){
        testData = ["user_terms_agreed" : "true"]
        app.launchEnvironment = testData
        app.launch()
        
        app.buttons["moto logo"].tap()
        
        let loginPage = app.buttons["SIGN IN"]
        waitForElementToAppear(element: loginPage)
        
        let guestButton = app.buttons["Continue as a Guest"]
        XCTAssertFalse(guestButton.exists)
        
    }
    
    
    
    func test_T2S7_ForogotButtonInMoto(){
         testData = ["user_terms_agreed" : "true"]
         app.launchEnvironment = testData
         app.launch()
         
         app.buttons["moto logo"].tap()
         
         let loginPage = app.buttons["SIGN IN"]
         waitForElementToAppear(element: loginPage)
         
         let guestButton = app.buttons["Forgot Password?"]
         XCTAssertTrue(guestButton.exists)
         
     }
    func test_T2S8_ForogotButtonInEV(){
             testData = ["user_terms_agreed" : "true"]
             app.launchEnvironment = testData
             app.launch()
             
             app.buttons["ev logo"].tap()
             
             let loginPage = app.buttons["SIGN IN"]
             waitForElementToAppear(element: loginPage)
             
             let guestButton = app.buttons["Forgot Password?"]
             XCTAssertTrue(guestButton.exists)
             
         }
    //  app2/*@START_MENU_TOKEN@*/.staticTexts["Forgot Password?"]/*[[".buttons[\"Forgot Password?\"].staticTexts[\"Forgot Password?\"]",".staticTexts[\"Forgot Password?\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
}
