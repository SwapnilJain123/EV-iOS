//
//  AdminSignatureInputTests.swift
//  UIAutomation
//
//  Created by Subair Ariyil on 01/08/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import XCTest

class T7AdminSignatureInputTests: BaseUITests {
    
    var canvas : XCUIElement!
    private func moveSignatureInputPage(evApp : Bool){
        
        testData = ["user_terms_agreed" : "true", "user_type": "admin","sign_updated":"true" ]
        moveToParticipantPage(evApp: true)
        
        let itemCell = app.tables.cells.containing(.staticText, identifier: "sign_and_trainging@test.com").firstMatch
        
        itemCell.buttons["signature"].tap()
        canvas = app.otherElements["SignatureCanvas"]
        waitForElementToAppear(element: canvas)
    }
    
    /**
     Test update signature in Ev
     */
    func test_T7S1_TestSignatureUploadEv(){
        
        moveSignatureInputPage(evApp: true)
        
        print(debugDescription)
        app.buttons["I accept the terms of this agreement"].tap()
        
        canvas.tap()
        canvas.swipeRight()
        canvas.swipeDown()
        canvas.swipeLeft()
        canvas.swipeUp()
        
        let saveButton = app.buttons["SaveSignature"]
        XCTAssertTrue(saveButton.exists)
        saveButton.tap()
        
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        let successAlert =  app.alerts["Signature Saved"]
        waitForElementToAppear(element: successAlert)
        
        successAlert.scrollViews.otherElements.buttons["OK"].tap()
        verifyPageTitle(title: "Events")
        
        
    }
    
    /**
     Test clear signature in Ev
     */
    func test_T7S2_TestSignatureClearEv(){
        
        moveSignatureInputPage(evApp: true)
        
        print(debugDescription)
        app.buttons["I accept the terms of this agreement"].tap()
        
        canvas.tap()
        canvas.swipeRight()
        canvas.swipeDown()
        canvas.swipeLeft()
        canvas.swipeUp()
        
        //                XCTAssertNil(canvas.value)
        
        let saveButton = app.buttons["SaveSignature"]
        XCTAssertTrue(saveButton.isEnabled)
        
        let clearButton = app.buttons["Clear Signature"]
        XCTAssertTrue(clearButton.exists)
        clearButton.tap()
        
        
        XCTAssertFalse(saveButton.isEnabled)
        
        
        
    }
    /**
        Test Terms Agreement in Ev
        */
       func test_T7S3_TestTermsAgreementInEv(){
           
           moveSignatureInputPage(evApp: true)
           
           
          
           
           canvas.tap()
           canvas.swipeRight()
           canvas.swipeDown()
           canvas.swipeLeft()
           canvas.swipeUp()
           
           //                XCTAssertNil(canvas.value)
           
        
           let saveButton = app.buttons["SaveSignature"]
           XCTAssertFalse(saveButton.isEnabled)
           
           app.buttons["I accept the terms of this agreement"].tap()
        
           XCTAssertTrue(saveButton.isEnabled)
           
           
           
       }
    /**
     Test Close Button in Ev
     */
    func test_T7S4_TestCloseButtonInEv(){
        
         moveSignatureInputPage(evApp: true)
        let closeButton = app.buttons["Close Signature"]
        XCTAssertTrue(closeButton.exists)
        
        closeButton.tap()
        
        verifyPageTitle(title: "Events")
        
        
    }
    
    /**
        Test Close Button in Ev
        */
       func test_T7S5_TestBackButtonInEv(){
           
            moveSignatureInputPage(evApp: true)
           let closeButton = app.buttons["Events"]
           XCTAssertTrue(closeButton.exists)
           
           closeButton.tap()
           
           verifyPageTitle(title: "Events")
           
           
       }
    
    /**
        Test update signature in Moto
        */
       func test_T7S6_TestSignatureUploadMoto(){
           
           moveSignatureInputPage(evApp: false)
           
           print(debugDescription)
           app.buttons["I accept the terms of this agreement"].tap()
           
           canvas.tap()
           canvas.swipeRight()
           canvas.swipeDown()
           canvas.swipeLeft()
           canvas.swipeUp()
           
           let saveButton = app.buttons["SaveSignature"]
           XCTAssertTrue(saveButton.exists)
           saveButton.tap()
           
           
           verifyActivityIndicatorIsShown()
           waitForActivityIndicatorToDisAppear()
           let successAlert =  app.alerts["Signature Saved"]
           waitForElementToAppear(element: successAlert)
           
           successAlert.scrollViews.otherElements.buttons["OK"].tap()
           verifyPageTitle(title: "Events")
           
           
       }
       
       /**
        Test clear signature in Moto
        */
       func test_T7S7_TestSignatureClearMoto(){
           
           moveSignatureInputPage(evApp: false)
           
           print(debugDescription)
           app.buttons["I accept the terms of this agreement"].tap()
           
           canvas.tap()
           canvas.swipeRight()
           canvas.swipeDown()
           canvas.swipeLeft()
           canvas.swipeUp()
           
           //                XCTAssertNil(canvas.value)
           
           let saveButton = app.buttons["SaveSignature"]
           XCTAssertTrue(saveButton.isEnabled)
           
           let clearButton = app.buttons["Clear Signature"]
           XCTAssertTrue(clearButton.exists)
           clearButton.tap()
           
           
           XCTAssertFalse(saveButton.isEnabled)
           
           
           
       }
       /**
           Test Terms Agreement in Moto
           */
          func test_T7S8_TestTermsAgreementInMoto(){
              
              moveSignatureInputPage(evApp: false)
              
              
             
              
              canvas.tap()
              canvas.swipeRight()
              canvas.swipeDown()
              canvas.swipeLeft()
              canvas.swipeUp()
              
              //                XCTAssertNil(canvas.value)
              
           
              let saveButton = app.buttons["SaveSignature"]
              XCTAssertFalse(saveButton.isEnabled)
              
              app.buttons["I accept the terms of this agreement"].tap()
           
              XCTAssertTrue(saveButton.isEnabled)
              
              
              
          }
       /**
        Test Close Button in Moto
        */
       func test_T7S9_TestCloseButtonInMoto(){
           
            moveSignatureInputPage(evApp: false)
           let closeButton = app.buttons["Close Signature"]
           XCTAssertTrue(closeButton.exists)
           
           closeButton.tap()
           
           verifyPageTitle(title: "Events")
           
           
       }
       
       /**
           Test Close Button in Moto
           */
          func test_T7S10_TestBackButtonInMoto(){
              
               moveSignatureInputPage(evApp: false)
              let closeButton = app.buttons["Events"]
              XCTAssertTrue(closeButton.exists)
              
              closeButton.tap()
              
              verifyPageTitle(title: "Events")
              
              
          }
}
