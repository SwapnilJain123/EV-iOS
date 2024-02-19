//
//  AdminSignatureViewTests.swift
//  UIAutomation
//
//  Created by Subair Ariyil on 01/08/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import XCTest
import Foundation
class T6AdminSignatureViewTests: BaseUITests {
    
    /**
     Test if the signature is rendered correctly in Ev
     */
    func test_T6S1_TestViewSavedSignatureInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin" ]
        moveToParticipantPage(evApp: true)
        
        let itemCell = app.tables.cells.containing(.staticText, identifier: "fulldetails@test.com").firstMatch
        
        itemCell.buttons["signature"].tap()
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        
        let signatureNavigationBar = app.navigationBars["Signature"]
        waitForElementToAppear(element: signatureNavigationBar)
        
        
        let signature = app.images["SignatureImage"].firstMatch
        XCTAssertTrue(signature.value != nil)
        
        
        
        
    }
    /**
     Test if the signature is rendered correctly in Ev
     */
    func test_T6S2_TestViewSavedSignatureInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin" ]
        moveToParticipantPage(evApp: false)
        
        let itemCell = app.tables.cells.containing(.staticText, identifier: "fulldetails@test.com").firstMatch
        
        itemCell.buttons["signature"].tap()
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        
        let signatureNavigationBar = app.navigationBars["Signature"]
        waitForElementToAppear(element: signatureNavigationBar)
        
        
        let signature = app.images["SignatureImage"].firstMatch
        XCTAssertTrue(signature.value != nil)
        
        
        
    }
    
    /**
     Test Close Button in the signature page in Ev
     */
    func test_T6S3_TestSignatureCloseButtonEv(){
        
        testData = ["user_terms_agreed" : "true", "user_type": "admin" ]
        moveToParticipantPage(evApp: true)
        
        let itemCell = app.tables.cells.containing(.staticText, identifier: "fulldetails@test.com").firstMatch
        
        itemCell.buttons["signature"].tap()
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        
        let signatureNavigationBar = app.navigationBars["Signature"]
        waitForElementToAppear(element: signatureNavigationBar)
        
        
        let signature = app.images["SignatureImage"].firstMatch
        XCTAssertTrue(signature.value != nil)
        app.staticTexts["CLOSE"].tap()
    }
    
    /**
     Test Close Button in the signature page in Moto
     */
    func test_T6S4_TestSignatureCloseButtonInMoto(){
        
        testData = ["user_terms_agreed" : "true", "user_type": "admin" ]
        moveToParticipantPage(evApp: false)
        
        let itemCell = app.tables.cells.containing(.staticText, identifier: "fulldetails@test.com").firstMatch
        
        itemCell.buttons["signature"].tap()
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        
        let signatureNavigationBar = app.navigationBars["Signature"]
        waitForElementToAppear(element: signatureNavigationBar)
        
        
        let signature = app.images["SignatureImage"].firstMatch
        XCTAssertTrue(signature.value != nil)
        app.staticTexts["CLOSE"].tap()
    }
    /**
     Test Back Button in the signature page in Ev
     */
    func test_T6S5_TestSignatureBackButtonEv(){
        
        testData = ["user_terms_agreed" : "true", "user_type": "admin" ]
        moveToParticipantPage(evApp: true)
        
        let itemCell = app.tables.cells.containing(.staticText, identifier: "fulldetails@test.com").firstMatch
        
        itemCell.buttons["signature"].tap()
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        
        let signatureNavigationBar = app.navigationBars["Signature"]
        waitForElementToAppear(element: signatureNavigationBar)
        
        let backButton = signatureNavigationBar.buttons["Events"]
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        let participantPage = app.navigationBars["Events"]
        XCTAssertTrue(participantPage.exists)
        
    }
    
    /**
     Test Back Button in the signature page in Moto
     */
    func test_T6S6_TestSignatureBackButtonMoto(){
        
        testData = ["user_terms_agreed" : "true", "user_type": "admin" ]
        moveToParticipantPage(evApp: false)
        
        let itemCell = app.tables.cells.containing(.staticText, identifier: "fulldetails@test.com").firstMatch
        
        itemCell.buttons["signature"].tap()
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        
        let signatureNavigationBar = app.navigationBars["Signature"]
        waitForElementToAppear(element: signatureNavigationBar)
        
        let backButton = signatureNavigationBar.buttons["Events"]
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        let participantPage = app.navigationBars["Events"]
        XCTAssertTrue(participantPage.exists)
        
    }
    
}
