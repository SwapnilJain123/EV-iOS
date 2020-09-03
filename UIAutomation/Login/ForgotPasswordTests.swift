//
//  ForgotPasswordTests.swift
//  UIAutomation
//
//  Created by Subair Ariyil on 04/08/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import XCTest

class T8ForgotPasswordUITest: BaseUITests {
    
    var page: XCUIElement!
    func moveToForgotPwdPage(isEvApp: Bool = true){
        
        app.launchEnvironment = testData
        app.launch()
        
        selectAppTheme(isEvApp: isEvApp)
        
        let loginPage = app.buttons["SIGN IN"]
        waitForElementToAppear(element: loginPage)
        
        let guestButton = app.buttons["Forgot Password?"]
        XCTAssertTrue(guestButton.exists)
        guestButton.tap()
        
        
        page = app.staticTexts["Please provide your registered email. We will send the password reset link to this email."]
        XCTAssertTrue(page.exists)
        
    }
    
    func verifyInvalidEmail(evApp:Bool){
        moveToForgotPwdPage(isEvApp: evApp)
        
        let submitButton = app.buttons["RESET PASSWORD"]
       
        
        let errorMessage =  app.staticTexts["Please enter valid email"]
        XCTAssertFalse(errorMessage.exists)
        
        let email = app.textFields["Email"]
        email.tap()
        email.typeText("forgotaccountwebeteer.com")
       
        page.tap()
        
        submitButton.tap()
        XCTAssertTrue(errorMessage.exists)
        
    }
    
    func test_T8S1_TestInavalidEmailInEV(){
        verifyInvalidEmail(evApp: true)
    }
    func test_T8S2_TestInavalidEmailInMoto(){
        verifyInvalidEmail(evApp: false)
    }
}
