//
//  UITests.swift
//  UITests
//
//  Created by Subair Ariyil on 19/07/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//


import XCTest
import UIKit

class BaseUITests: XCTestCase {

    let app = XCUIApplication()
    override func setUp() {
         super.setUp()
        app.launchArguments += ["UI-Testing", "YES"]
         app.launch()
     }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
       
    }

    func hideKeyboard(){
        app.keyboards.buttons["Done"].tap()
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
}
