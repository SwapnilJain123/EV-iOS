//
//  UITests.swift
//  UITests
//
//  Created by Subair Ariyil on 19/07/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//


import XCTest
import UIKit
import Foundation

class BaseUITests: XCTestCase {
    
    let app = XCUIApplication()
   
    var testData = [String: String]()
    
  
    override func setUp() {
        super.setUp()
        app.launchArguments += ["UI-Testing"]
        
       
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }
    
    func hideKeyboard(key: String = "Done"){
        app.keyboards.buttons[key].tap()
    }
    func hideKeyboard(returnKey: String){
        app.keyboards.buttons[returnKey].tap()
    }
    
    func selectAppTheme(isEvApp:Bool){
        if isEvApp{
            app.buttons["ev logo"].tap()
        }else{
            app.buttons["moto logo"].tap()
        }
    }
    
    func moveToParticipantPage(evApp: Bool = true){
        loginAdminUser(isEvApp: evApp)
        let eventsPage = app.staticTexts["Events"]
        waitForElementToAppear(element: eventsPage)
        XCTAssertTrue(eventsPage.exists)
        
        let tablesQuery = app.tables
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        waitForElementToAppear(element: app.tables.firstMatch)
        if evApp{
            tablesQuery.staticTexts["NYST 07-18"].tap()
        }else{
            tablesQuery.staticTexts["CMC 07-21 Moto"].tap()
        }
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        waitForElementToAppear(element: app.tables.firstMatch)
        
        let pageLabel = app.staticTexts["Indicates the user not signed the disclaimer yet."]
        verifyExistence(element: pageLabel)
        
        let text = "Showing \(tablesQuery.cells.count) users"
        let usersCount = app.staticTexts[text]
        
        if tablesQuery.cells.count > 0{
            XCTAssertTrue(usersCount.exists)
        }
        
    }
    
    func waitForElementToAppear(element: XCUIElement, file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: 1.5) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after 1.5 seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: Int(line), expected: true)
            }
        }
    }
    
    func verifyPageTitle(title: String){
        let page = app.navigationBars[title]
        waitForElementToAppear(element: page)
        XCTAssert(page.exists)
    }
    
    func verifyTitle(title: String){
        let page = app.staticTexts[title]
        waitForElementToAppear(element: page)
        XCTAssert(page.exists)
    }
    
    func verifyExistence(element: XCUIElement){
        let exists = element.waitForExistence(timeout: 1.0)
        XCTAssertTrue(exists,"Missing Element - \(element)")
    }
    
    func loginAdminUser(isEvApp: Bool = true){
          
          app.launchEnvironment = testData
          app.launch()
          
          if isEvApp{
              app.buttons["ev logo"].tap()
          }else{
              app.buttons["moto logo"].tap()
          }
          app.textFields["Email"].tap()
          app.textFields["Email"].typeText("adminuser@gmail.com")
          hideKeyboard()
          
          app.secureTextFields["Password"].tap()
          app.secureTextFields["Password"].typeText("admin@123")
          hideKeyboard()
          app.buttons["SIGN IN"].tap()
          
      }
    
    func loginAsRegularUser(isEvApp: Bool = true){
        
        app.launchEnvironment = testData
        app.launch()
        
        if isEvApp{
            app.buttons["ev logo"].tap()
        }else{
            app.buttons["moto logo"].tap()
        }
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("regularuser@gmail.com")
        hideKeyboard()
        
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("user@123")
        hideKeyboard()
        app.buttons["SIGN IN"].tap()
        
    }
    
    func loginAsCoach(isEvApp: Bool = true){
        
        app.launchEnvironment = testData
        app.launch()
        
        if isEvApp{
            app.buttons["ev logo"].tap()
        }else{
            app.buttons["moto logo"].tap()
        }
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("coach@gmail.com")
        hideKeyboard()
        
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("coach@123")
        hideKeyboard()
        app.buttons["SIGN IN"].tap()
        
    }
    
    func verifyVisibility(element: XCUIElement){
        let window = app.windows.element(boundBy: 0)
        XCTAssert(window.frame.contains(element.frame))
    }
    
    func verifyActivityIndicatorIsShown(){
        let element = app/*@START_MENU_TOKEN@*/.otherElements["SVProgressHUD"]/*[[".otherElements[\"Loading participants...\"]",".otherElements[\"SVProgressHUD\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        verifyExistence(element: element)
    }
    
    func waitForElementToDisAppear(element: XCUIElement, file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == false")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: 3) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after 3 seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: Int(line), expected: true)
            }
        }
    }
    func waitForActivityIndicatorToDisAppear(file: String = #file, line: UInt = #line) {
        let element = app/*@START_MENU_TOKEN@*/.otherElements["SVProgressHUD"]/*[[".otherElements[\"Loading participants...\"]",".otherElements[\"SVProgressHUD\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let existsPredicate = NSPredicate(format: "exists == false")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: 3) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after 3 seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: Int(line), expected: true)
            }
        }
    }
    
    func verifyErrorViewIsShown(){
        let element = app.staticTexts["VCErrorView"]
        verifyVisibility(element: element)
    }
    
    func getErrorViewText() -> String{
        app.staticTexts["VCErrorView"].value as! String
    }
    
    
    func verifyLoginPage(){
        let itemInAppSelection = app.buttons["ev logo"]
        waitForElementToAppear(element: itemInAppSelection)
    }
}
