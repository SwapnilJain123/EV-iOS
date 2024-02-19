//
//  AdminCompletedEventsTests.swift
//  UIAutomation
//
//  Created by Subair Ariyil on 26/07/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//
import XCTest
import Foundation
class T4AdminCompletedEventsTests: BaseUITests {
    /**
     Test Admin landing page
     */
    func test_T4S1_AdminLandingPage(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0"]
        loginAdminUser()
        let eventsPage = app.staticTexts["Events"]
        waitForElementToAppear(element: eventsPage)
        
        XCTAssertTrue(eventsPage.exists)
    }
    
    /**
     Test Admin completed events in Ev Mode where events does not have any trainings
     */
    func test_T4S2_AdminCompletedEventsForEvEventsWithNoTraining(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0" ]
        loginAdminUser()
        let eventsPage = app.staticTexts["Events"]
        waitForElementToAppear(element: eventsPage)
        XCTAssertTrue(eventsPage.exists)
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        waitForElementToAppear(element: app.tables.firstMatch)
        XCTAssertTrue(app.tables.firstMatch.exists)
    }
    
    /**
     Test Admin completed events in Ev Mode where events  have  trainings
     */
    func test_T4S3_AdminCompletedEventsForEvEventsWithTraining(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "1" ]
        loginAdminUser()
        let eventsPage = app.staticTexts["Events"]
        waitForElementToAppear(element: eventsPage)
        XCTAssertTrue(eventsPage.exists)
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        waitForElementToAppear(element: app.tables.firstMatch)
        XCTAssertTrue(app.tables.firstMatch.exists)
    }
    
    /**
     Test Admin completed events in Moto Mode
     */
    func test_T4S4_AdminCompletedEventsForMotoEvents(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0" ]
        loginAdminUser(isEvApp: false)
        let eventsPage = app.staticTexts["Events"]
        waitForElementToAppear(element: eventsPage)
        XCTAssertTrue(eventsPage.exists)
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        waitForElementToAppear(element: app.tables.firstMatch)
        XCTAssertTrue(app.tables.firstMatch.exists)
    }
    
    /**
     Test Search in Admin completed events in Ev Mode
     */
    func test_T4S5_SearchCompletedEvEvents(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0" ]
        
        loginAdminUser()
        
        let eventsPage = app.staticTexts["Events"]
        waitForElementToAppear(element: eventsPage)
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        
        waitForElementToAppear(element: app.tables.firstMatch)
        
        app.navigationBars["Events"].buttons["three dots"].tap()
        let search = app.buttons["Search"]
        waitForElementToAppear(element: search)
        search.tap()
        
        
        
        let searchFiled = app.tables.otherElements["EventSearch"]//.searchFields.firstMatch
        waitForElementToAppear(element: searchFiled)
        XCTAssertTrue(searchFiled.exists)
        searchFiled.tap()
        searchFiled.typeText("NYST")
        hideKeyboard(key: "Search")
        
        waitForElementToAppear(element: app.tables.firstMatch)
        XCTAssertTrue(app.tables.cells.count == 1)
        
        
        searchFiled.tap()
        app.buttons["Clear text"].tap()
        searchFiled.typeText("ZZZZ")
        hideKeyboard(key: "Search")
        
        let errorView = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH %@", "Sorry, we")).firstMatch
        
        waitForElementToAppear(element: errorView)
        XCTAssertTrue(errorView.exists)
        
    }
    /**
     Test Search in Admin completed events in Moto Mode where
     */
    func test_T4S6_SearchCompletedMotoEvents(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0" ]
        
        loginAdminUser(isEvApp: false)
        
        let eventsPage = app.navigationBars["Events"]
        waitForElementToAppear(element: eventsPage)
        
        verifyExistence(element: app.tables.firstMatch)
        
        app.navigationBars["Events"].buttons["three dots"].tap()
        let search = app.buttons["Search"]
        waitForElementToAppear(element: search)
        search.tap()
        
        
        
        let searchFiled = app.tables.otherElements["EventSearch"]
        waitForElementToAppear(element: searchFiled)
        XCTAssertTrue(searchFiled.exists)
        searchFiled.tap()
        searchFiled.typeText("NCBIKE")
        hideKeyboard(key: "Search")
        
        waitForElementToAppear(element: app.tables.firstMatch)
        XCTAssertTrue(app.tables.cells.count == 1)
        
        
        searchFiled.tap()
        app.buttons["Clear text"].tap()
        searchFiled.typeText("ZZZZ")
        hideKeyboard(key: "Search")
        
        let errorView = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH %@", "Sorry, we")).firstMatch
        
        waitForElementToAppear(element: errorView)
        XCTAssertTrue(errorView.exists)
        
    }
    
    /**
     Test app mode switch from Ev To Moto
     */
    func test_T4S7_SwitchFromEvToMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0" ]
        
        loginAdminUser(isEvApp: true)
        verifyPageTitle(title: "Events")
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        verifyExistence(element: app.tables.firstMatch)
        XCTAssert(app.tables.cells.count == 3)
        
        
        app.navigationBars["Events"].buttons["three dots"].tap()
        let switchButton = app.buttons["switch moto"]
        waitForElementToAppear(element: switchButton)
        switchButton.tap()
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        waitForElementToAppear(element: app.tables.firstMatch)
        
        XCTAssert(app.tables.cells.count == 4)
        
        
    }
    
    /**
     Test app mode switch from Moto To Ev
     */
    func test_T4S8_SwitchFromMotoToEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0" ]
        
        loginAdminUser(isEvApp: false)
        verifyPageTitle(title: "Events")
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        
        verifyExistence(element: app.tables.firstMatch)
        XCTAssert(app.tables.cells.count == 4)
        
        
        app.navigationBars["Events"].buttons["three dots"].tap()
        let switchButton = app.buttons["switch ev"]
        waitForElementToAppear(element: switchButton)
        switchButton.tap()
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        
        waitForElementToAppear(element: app.tables.firstMatch)
        
        XCTAssert(app.tables.cells.count == 3)
        
        
    }
    
    /**
     Test to filter the ev event by month
     */
    func test_T4S9_FilterEvEventsByMonth(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0" ]
        
        loginAdminUser(isEvApp: true)
        verifyPageTitle(title: "Events")
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        
        verifyExistence(element: app.tables.firstMatch)
        XCTAssert(app.tables.cells.count == 3)
        
        
        let threeDotsButton = app.navigationBars["Events"].buttons["three dots"]
        threeDotsButton.tap()
        
        let filterButton = app.buttons["filter"]
        waitForElementToAppear(element: filterButton)
        filterButton.tap()
        
        let byMonthButton = app.alerts["Select filter"].scrollViews.otherElements.buttons["By Month"]
        waitForElementToAppear(element: byMonthButton)
        byMonthButton.tap()
        
        
        
        let filterByMonthStaticText = app.navigationBars["Filter by Month"].staticTexts["Filter by Month"]
        waitForElementToAppear(element: filterByMonthStaticText)
        XCTAssert(filterByMonthStaticText.exists)
        
        let selectionTable =  app.tables["SelectionMenuTableView"]
        waitForElementToAppear(element: selectionTable)
        XCTAssert(selectionTable.cells.count == 3)
        
        let filterOption = selectionTable/*@START_MENU_TOKEN@*/.cells.staticTexts["Jul 2020"]/*[[".cells.staticTexts[\"Jul 2020\"]",".staticTexts[\"Jul 2020\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        
        filterOption.tap()
        
        verifyPageTitle(title: "Events")
        
        XCTAssert(app.tables.cells.count == 1)
        
        
    }
    
    /**
     Test to filter the moto event by month
     */
    func test_T4S10_FilterMotoEventsByMonth(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0" ]
        
        loginAdminUser(isEvApp: false)
        verifyPageTitle(title: "Events")
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        
        verifyExistence(element: app.tables.firstMatch)
        XCTAssert(app.tables.cells.count == 4)
        
        
        let threeDotsButton = app.navigationBars["Events"].buttons["three dots"]
        threeDotsButton.tap()
        
        let filterButton = app.buttons["filter"]
        waitForElementToAppear(element: filterButton)
        filterButton.tap()
        
        let byMonthButton = app.alerts["Select filter"].scrollViews.otherElements.buttons["By Month"]
        waitForElementToAppear(element: byMonthButton)
        byMonthButton.tap()
        
        
        let filterByMonthStaticText = app.navigationBars["Filter by Month"].staticTexts["Filter by Month"]
        waitForElementToAppear(element: filterByMonthStaticText)
        XCTAssert(filterByMonthStaticText.exists)
        
        
        let selectionTable =  app.tables["SelectionMenuTableView"]
        waitForElementToAppear(element: selectionTable)
        XCTAssert(selectionTable.cells.count == 3)
        
        let filterOption = selectionTable/*@START_MENU_TOKEN@*/.cells.staticTexts["Jul 2020"]/*[[".cells.staticTexts[\"Jul 2020\"]",".staticTexts[\"Jul 2020\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        waitForElementToAppear(element: filterOption)
        filterOption.tap()
        
        verifyPageTitle(title: "Events")
        
        XCTAssert(app.tables.cells.count == 2)
        
        
    }
    
    /**
     Test filter option by training is not available when events have no training
     */
    func test_T4S11_FilterTrainingNotAvailableWhenEventsHaveNoTrainings(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0" ]
        
        loginAdminUser(isEvApp: true)
        verifyPageTitle(title: "Events")
        verifyExistence(element: app.tables.firstMatch)
        XCTAssert(app.tables.cells.count == 3)
        
        let threeDotsButton = app.navigationBars["Events"].buttons["three dots"]
        threeDotsButton.tap()
        
        let filterButton = app.buttons["filter"]
        waitForElementToAppear(element: filterButton)
        filterButton.tap()
        
        let byTrainingType = app.alerts["Select filter"].scrollViews.otherElements.buttons["By Training Type"]
        XCTAssertFalse(byTrainingType.exists)
    }
    /**
     Test filter option by training is not available when events have no training in Moto
     */
    func test_T4S12_FilterTrainingNotAvailableWhenEventsHaveNoTrainingsInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0" ]
        
        loginAdminUser(isEvApp: false)
        verifyPageTitle(title: "Events")
        
        verifyExistence(element: app.tables.firstMatch)
        
        let threeDotsButton = app.navigationBars["Events"].buttons["three dots"]
        threeDotsButton.tap()
        
        let filterButton = app.buttons["filter"]
        waitForElementToAppear(element: filterButton)
        filterButton.tap()
        
        let byTrainingType = app.alerts["Select filter"].scrollViews.otherElements.buttons["By Training Type"]
        XCTAssertFalse(byTrainingType.exists)
    }
    /**
     Test filter option by training is available when events have training
     */
    func test_T4S13_FilterTrainingAvailableWhenEventsHaveTrainings(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "1" ]
        
        loginAdminUser(isEvApp: true)
        verifyPageTitle(title: "Events")
        
        
        
        let threeDotsButton = app.navigationBars["Events"].buttons["three dots"]
        threeDotsButton.tap()
        
        let filterButton = app.buttons["filter"]
        waitForElementToAppear(element: filterButton)
        filterButton.tap()
        
        let byTrainingType = app.alerts["Select filter"].scrollViews.otherElements.buttons["By Training Type"]
        XCTAssertTrue(byTrainingType.exists)
    }
    
    /**
     Test tapping cancel button when the filter items are presented
     */
    func test_T4S14_TestFilterOptionCancelButton(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0" ]
        
        loginAdminUser(isEvApp: true)
        verifyPageTitle(title: "Events")
        
        verifyExistence(element: app.tables.firstMatch)
        
        let threeDotsButton = app.navigationBars["Events"].buttons["three dots"]
        threeDotsButton.tap()
        
        let filterButton = app.buttons["filter"]
        waitForElementToAppear(element: filterButton)
        filterButton.tap()
        
        
        let byMonthButton = app.alerts["Select filter"].scrollViews.otherElements.buttons["By Month"]
        waitForElementToAppear(element: byMonthButton)
        byMonthButton.tap()
        
        
        let filterByMonthStaticText = app.navigationBars["Filter by Month"].staticTexts["Filter by Month"]
        waitForElementToAppear(element: filterByMonthStaticText)
        XCTAssert(filterByMonthStaticText.exists)
        
        app.navigationBars["Filter by Month"].buttons["Cancel"].tap()
        
        verifyPageTitle(title: "Events")
        XCTAssert(app.tables.cells.count == 3)
    }
    
    /**
     Test tapping cancel button when the filter items are presented
     */
    func test_T4S15_TestFilterOptionCancelButtonInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0" ]
        
        loginAdminUser(isEvApp: false)
        verifyPageTitle(title: "Events")
        
        verifyExistence(element: app.tables.firstMatch)
        
        let threeDotsButton = app.navigationBars["Events"].buttons["three dots"]
        threeDotsButton.tap()
        
        let filterButton = app.buttons["filter"]
        waitForElementToAppear(element: filterButton)
        filterButton.tap()
        
        
        let byMonthButton = app.alerts["Select filter"].scrollViews.otherElements.buttons["By Month"]
        waitForElementToAppear(element: byMonthButton)
        byMonthButton.tap()
        
        
        let filterByMonthStaticText = app.navigationBars["Filter by Month"].staticTexts["Filter by Month"]
        waitForElementToAppear(element: filterByMonthStaticText)
        XCTAssert(filterByMonthStaticText.exists)
        
        app.navigationBars["Filter by Month"].buttons["Cancel"].tap()
        
        verifyPageTitle(title: "Events")
        XCTAssert(app.tables.cells.count == 4)
    }
    
    /**
     Test tapping switch dashboard in Ev
     */
    func test_T4S16_TestSwitchDashboardInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0" ]
        
        loginAdminUser(isEvApp: true)
        verifyPageTitle(title: "Events")
        
        verifyExistence(element: app.tables.firstMatch)
        
        app.navigationBars["Events"].buttons["SwictUserWhite"].tap()
        verifyPageTitle(title: "Dashboard")
    }
    /**
     Test tapping switch dashboard in Moto
     */
    func test_T4S17_TestSwitchDashboardInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0" ]
        
        loginAdminUser(isEvApp: false)
        verifyPageTitle(title: "Events")
        
        app.navigationBars["Events"].buttons["SwictUserWhite"].tap()
        verifyPageTitle(title: "Dashboard")
    }
    
    /**
     Test tapping Logout in ev
     */
    func test_T4S18_TestLogoutInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0" ]
        
        loginAdminUser(isEvApp: true)
        verifyPageTitle(title: "Events")
        
        verifyExistence(element: app.tables.firstMatch)
        
        app.navigationBars["Events"].buttons["three dots"].tap()
        let logout =  app.buttons["logout"]
        waitForElementToAppear(element: logout)
        logout.tap()
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        
        let itemInAppSelection = app.buttons["ev logo"]
        waitForElementToAppear(element: itemInAppSelection)
        
        
    }
    /**
     Test tapping Logout in Moto
     */
    func test_T4S19_TestLogoutInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0" ]
        
        loginAdminUser(isEvApp: false)
        verifyPageTitle(title: "Events")
        
        verifyExistence(element: app.tables.firstMatch)
        
        app.navigationBars["Events"].buttons["three dots"].tap()
        let logout =  app.buttons["logout"]
        waitForElementToAppear(element: logout)
        logout.tap()
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        
        let itemInAppSelection = app.buttons["ev logo"]
        waitForElementToAppear(element: itemInAppSelection)
        
        
    }
    /**
     Test verify empty Events In EV
     */
    func test_T4S20_TestEmptyList(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_result" : "true" ]
        
        loginAdminUser(isEvApp: true)
        verifyPageTitle(title: "Events")
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        waitForElementToAppear(element: app.tables.firstMatch)
        XCTAssertTrue(app.tables.firstMatch.exists)
        XCTAssertTrue(app.tables.firstMatch.cells.count == 0)
        
        verifyErrorViewIsShown()
        
        let message = "Sorry, there are currently no events available."
        XCTAssertTrue(app.staticTexts[message].exists)
    }
    /**
     Test verify empty Events In Moto
     */
    func test_T4S21_TestEmptyListInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_result" : "true" ]
        
        loginAdminUser(isEvApp: false)
        verifyPageTitle(title: "Events")
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        waitForElementToAppear(element: app.tables.firstMatch)
        XCTAssertTrue(app.tables.firstMatch.exists)
        XCTAssertTrue(app.tables.firstMatch.cells.count == 0)
        
        verifyErrorViewIsShown()
        
        let message = "Sorry, there are currently no events available."
        XCTAssertTrue(app.staticTexts[message].exists)
    }
    
    /**
     Test verify empty Events In EV
     */
    func test_T4S22_TestFilterInEmptyList(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_result" : "true" ]
        
        loginAdminUser(isEvApp: true)
        verifyPageTitle(title: "Events")
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        waitForElementToAppear(element: app.tables.firstMatch)
        XCTAssertTrue(app.tables.firstMatch.exists)
        XCTAssertTrue(app.tables.firstMatch.cells.count == 0)
        
        verifyErrorViewIsShown()
        
        let message = "Sorry, there are currently no events available."
        XCTAssertTrue(app.staticTexts[message].exists)
        
        let threeDotsButton = app.navigationBars["Events"].buttons["three dots"]
        threeDotsButton.tap()
        
        let filterButton = app.buttons["filter"]
        waitForElementToAppear(element: filterButton)
        filterButton.tap()
        
        let alert = app.alerts["Select filter"]
        XCTAssertFalse(alert.exists)
    }
    
    /**
     Test verify empty Events In EV
     */
    func test_T4S23_TestSearchInEmptyList(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_result" : "true" ]
        
        loginAdminUser(isEvApp: true)
        verifyPageTitle(title: "Events")
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        waitForElementToAppear(element: app.tables.firstMatch)
        XCTAssertTrue(app.tables.firstMatch.exists)
        XCTAssertTrue(app.tables.firstMatch.cells.count == 0)
        
        verifyErrorViewIsShown()
        
        let message = "Sorry, there are currently no events available."
        XCTAssertTrue(app.staticTexts[message].exists)
        
        let threeDotsButton = app.navigationBars["Events"].buttons["three dots"]
        threeDotsButton.tap()
        
       let search = app.buttons["Search"]
       waitForElementToAppear(element: search)
       search.tap()
       
       let searchFiled = app.tables.otherElements["EventSearch"]
       XCTAssertFalse(searchFiled.exists)
        
    
    }
    
    /**
        Test Filter In EmptyList In Moto
        */
       func test_T4S24_TestFilterInEmptyListInMoto(){
           testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_result" : "true" ]
           
           loginAdminUser(isEvApp: false)
           verifyPageTitle(title: "Events")
           
           verifyActivityIndicatorIsShown()
           waitForActivityIndicatorToDisAppear()
           waitForElementToAppear(element: app.tables.firstMatch)
           XCTAssertTrue(app.tables.firstMatch.exists)
           XCTAssertTrue(app.tables.firstMatch.cells.count == 0)
           
           verifyErrorViewIsShown()
           
           let message = "Sorry, there are currently no events available."
           XCTAssertTrue(app.staticTexts[message].exists)
           
           let threeDotsButton = app.navigationBars["Events"].buttons["three dots"]
           threeDotsButton.tap()
           
           let filterButton = app.buttons["filter"]
           waitForElementToAppear(element: filterButton)
           filterButton.tap()
           
           let alert = app.alerts["Select filter"]
           XCTAssertFalse(alert.exists)
       }
       
       /**
        Test Search In EmptyList In Moto
        */
       func test_T4S25_TestSearchInEmptyListInMoto(){
           testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_result" : "true" ]
           
           loginAdminUser(isEvApp: false)
           verifyPageTitle(title: "Events")
           
           verifyActivityIndicatorIsShown()
           waitForActivityIndicatorToDisAppear()
           waitForElementToAppear(element: app.tables.firstMatch)
           XCTAssertTrue(app.tables.firstMatch.exists)
           XCTAssertTrue(app.tables.firstMatch.cells.count == 0)
           
           verifyErrorViewIsShown()
           
           let message = "Sorry, there are currently no events available."
           XCTAssertTrue(app.staticTexts[message].exists)
           
           let threeDotsButton = app.navigationBars["Events"].buttons["three dots"]
           threeDotsButton.tap()
           
          let search = app.buttons["Search"]
          waitForElementToAppear(element: search)
          search.tap()
          
          let searchFiled = app.tables.otherElements["EventSearch"]
          XCTAssertFalse(searchFiled.exists)
           
       
       }
    
}
