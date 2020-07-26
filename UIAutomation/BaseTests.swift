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
    
    func waitForElementToAppear(element: XCUIElement, file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: 5) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after 5 seconds."
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
        let exists = element.waitForExistence(timeout: 3.0)
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
}
