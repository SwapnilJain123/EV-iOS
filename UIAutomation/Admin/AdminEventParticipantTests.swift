//
//  AdminEventParticipantTests.swift
//  UIAutomation
//
//  Created by Subair Ariyil on 27/07/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import XCTest
import Foundation
class T5AdminEventParticipantTests: BaseUITests {
    
    
    
    private func tapFilter(){
        let eventsNavigationBar = app.navigationBars["Events"]
        eventsNavigationBar.buttons["filter"].tap()
    }
    private func tapSearch(){
        let searchButton = app.navigationBars["Events"].buttons["Search"]
        searchButton.tap()
    }
    
    private func search(text: String){
        
        let searchField = app.searchFields["Search participants here"]
        waitForElementToAppear(element: searchField)
        searchField.tap()
        
        let clear = searchField.buttons["Clear text"]
        if clear.exists{
            clear.tap()
        }
        searchField.tap()
        searchField.typeText(text)
        
        //tap out side kryboard to hide keyboard
        let pageLabel = app.staticTexts["Indicates the user not signed the disclaimer yet."]
        if pageLabel.isHittable{
            pageLabel.tap()
        }
        
    }
    
    private func verifyFilterTypeNotExists(type: String){
        let filterAlert =  app.alerts["Select Filter"]
        waitForElementToAppear(element: filterAlert)
        let filterType = filterAlert.scrollViews.otherElements.buttons[type]
        XCTAssertFalse(filterType.exists)
    }
    private func selectFilterType(type: String){
        let filterAlert =  app.alerts["Select Filter"]
        waitForElementToAppear(element: filterAlert)
        
        let filterType = filterAlert.scrollViews.otherElements.buttons[type]
        XCTAssertTrue(filterType.exists)
        filterType.tap()
    }
    private func selectFilter(option: String){
        let page = app.tables["SelectionMenuTableView"]
        waitForElementToAppear(element: page)
        let option = page.staticTexts[option]
        XCTAssertTrue(option.exists)
        option.tap()
        
        let pageLabel = app.staticTexts["Indicates the user not signed the disclaimer yet."]
        waitForElementToAppear(element: pageLabel)
        verifyExistence(element: pageLabel)
    }
    /**
     Test Participant Details
     */
    func test_T5S1_ParticipantWithAllDetailsInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0"]
        
        moveToParticipantPage()
        
        let tablesQuery = app.tables
        
        let fullDetailsCell = tablesQuery.cells.containing(.staticText, identifier: "fulldetails@test.com").firstMatch
        
        XCTAssert(fullDetailsCell.exists)
        
        let accessoryButton = fullDetailsCell.buttons["accessories"]
        XCTAssert(accessoryButton.exists)
        
        let signature = fullDetailsCell.buttons["signature"]
        XCTAssert(signature.exists)
        
        let fullName = fullDetailsCell.staticTexts["UI TESTER1(COACH)"]
        XCTAssert(fullName.exists)
        
        let userId = fullDetailsCell.staticTexts["#1001"]
        XCTAssert(userId.exists)
        
        let orderId = fullDetailsCell.staticTexts["#14676"]
        XCTAssert(orderId.exists)
        
        let dob = fullDetailsCell.staticTexts["06 Jul 1976"]
        XCTAssert(dob.exists)
        
        let skill = fullDetailsCell.staticTexts["E2"]
        XCTAssert(skill.exists)
        
    }
    
    /**
     Test Participant Details with training and signature
     */
    func test_T5S2_ParticipantWithSignatureAndTrainingInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0"]
        
        moveToParticipantPage()
        
        let tablesQuery = app.tables
        
        let fullDetailsCell = tablesQuery.cells.containing(.staticText, identifier: "sign_and_trainging@test.com").firstMatch
        XCTAssert(fullDetailsCell.exists)
        
        let accessoryButton = fullDetailsCell.buttons["accessories"]
        XCTAssert(accessoryButton.exists)
        
        let signature = fullDetailsCell.buttons["signature"]
        XCTAssert(signature.exists)
        
        let fullName = fullDetailsCell.staticTexts["UI TESTER2(APEX)"]
        XCTAssert(fullName.exists)
        
        let userId = fullDetailsCell.staticTexts["#1002"]
        XCTAssert(userId.exists)
        
        let orderId = fullDetailsCell.staticTexts["#15138"]
        XCTAssert(orderId.exists)
        
        let dob = fullDetailsCell.staticTexts["31 Jul 1995"]
        XCTAssert(dob.exists)
        
        let skill = fullDetailsCell.staticTexts["E3"]
        XCTAssert(skill.exists)
        
    }
    
    /**
     Test Participant Details with training Only
     */
    func test_T5S3_ParticipantWithTrainingOnlyInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0"]
        
        moveToParticipantPage()
        
        let tablesQuery = app.tables
        
        let fullDetailsCell = tablesQuery.cells.containing(.staticText, identifier: "trainging_only@test.com").firstMatch
        XCTAssert(fullDetailsCell.exists)
        
        let accessoryButton = fullDetailsCell.buttons["accessories"]
        XCTAssert(accessoryButton.exists)
        
        let signature = fullDetailsCell.buttons["signature"]
        XCTAssertFalse(signature.exists)
        
        let fullName = fullDetailsCell.staticTexts["UI TESTER3(GUEST)"]
        XCTAssert(fullName.exists)
        
        let userId = fullDetailsCell.staticTexts["#1003"]
        XCTAssert(userId.exists)
        
        let orderId = fullDetailsCell.staticTexts["#15153"]
        XCTAssert(orderId.exists)
        
        let dob = fullDetailsCell.staticTexts["07 Dec 1992"]
        XCTAssert(dob.exists)
        
        let skill = fullDetailsCell.staticTexts["GT1"]
        XCTAssert(skill.exists)
        
    }
    
    /**
     Test Participant Details with rentals only     */
    func test_T5S4_ParticipantWithRentalsOnlyInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0"]
        
        moveToParticipantPage()
        
        let tablesQuery = app.tables
        
        let fullDetailsCell = tablesQuery.cells.containing(.staticText, identifier: "rentals_only@test.com").firstMatch
        XCTAssert(fullDetailsCell.exists)
        
        let accessoryButton = fullDetailsCell.buttons["accessories"]
        XCTAssert(accessoryButton.exists)
        
        let signature = fullDetailsCell.buttons["signature"]
        XCTAssertFalse(signature.exists)
        
        let fullName = fullDetailsCell.staticTexts["UI TESTER4(GUEST)"]
        XCTAssert(fullName.exists)
        
        let userId = fullDetailsCell.staticTexts["#1004"]
        XCTAssert(userId.exists)
        
        let orderId = fullDetailsCell.staticTexts["#15182"]
        XCTAssert(orderId.exists)
        
        let dob = fullDetailsCell.staticTexts["13 Feb 1965"]
        XCTAssert(dob.exists)
        
        let skill = fullDetailsCell.staticTexts["E1"]
        XCTAssert(skill.exists)
        
    }
    
    /**
     Test Participant Details with no sign or accessories     */
    func test_T5S5_ParticipantWithNoSignNoAccessoriesInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0"]
        
        moveToParticipantPage()
        
        let tablesQuery = app.tables
        
        let fullDetailsCell = tablesQuery.cells.containing(.staticText, identifier: "nodetails@test.com").firstMatch
        XCTAssert(fullDetailsCell.exists)
        
        let accessoryButton = fullDetailsCell.buttons["accessories"]
        XCTAssertFalse(accessoryButton.exists)
        
        let signature = fullDetailsCell.buttons["signature"]
        XCTAssertFalse(signature.exists)
        
        let fullName = fullDetailsCell.staticTexts["UI TESTER5(GUEST)"]
        XCTAssert(fullName.exists)
        
        let userId = fullDetailsCell.staticTexts["#1005"]
        XCTAssert(userId.exists)
        
        let orderId = fullDetailsCell.staticTexts["#21182"]
        XCTAssert(orderId.exists)
        
        let dob = fullDetailsCell.staticTexts["13 Oct 1985"]
        XCTAssert(dob.exists)
        
        let skill = fullDetailsCell.staticTexts["E1"]
        XCTAssert(skill.exists)
        
    }
    
    /////
    /**
     Test Participant Details
     */
    func test_T5S6_ParticipantWithAllDetailsInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0"]
        
        moveToParticipantPage(evApp: false)
        
        let tablesQuery = app.tables
        
        let fullDetailsCell = tablesQuery.cells.containing(.staticText, identifier: "fulldetails@test.com").firstMatch
        XCTAssert(fullDetailsCell.exists)
        
        let accessoryButton = fullDetailsCell.buttons["accessories"]
        XCTAssert(accessoryButton.exists)
        
        let signature = fullDetailsCell.buttons["signature"]
        XCTAssert(signature.exists)
        
        let fullName = fullDetailsCell.staticTexts["UI TESTER1(COACH)"]
        XCTAssert(fullName.exists)
        
        let userId = fullDetailsCell.staticTexts["#1001"]
        XCTAssert(userId.exists)
        
        let orderId = fullDetailsCell.staticTexts["#14676"]
        XCTAssert(orderId.exists)
        
        let dob = fullDetailsCell.staticTexts["06 Jul 1976"]
        XCTAssert(dob.exists)
        
        let skill = fullDetailsCell.staticTexts["E2"]
        XCTAssert(skill.exists)
        
    }
    
    /**
     Test Participant Details with training and signature
     */
    func test_T5S7_ParticipantWithSignatureAndTrainingInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0"]
        
        moveToParticipantPage(evApp: false)
        
        let tablesQuery = app.tables
        
        let fullDetailsCell = tablesQuery.cells.containing(.staticText, identifier: "sign_and_trainging@test.com").firstMatch
        XCTAssert(fullDetailsCell.exists)
        
        let accessoryButton = fullDetailsCell.buttons["accessories"]
        XCTAssert(accessoryButton.exists)
        
        let signature = fullDetailsCell.buttons["signature"]
        XCTAssert(signature.exists)
        
        let fullName = fullDetailsCell.staticTexts["UI TESTER2(APEX)"]
        XCTAssert(fullName.exists)
        
        let userId = fullDetailsCell.staticTexts["#1002"]
        XCTAssert(userId.exists)
        
        let orderId = fullDetailsCell.staticTexts["#15138"]
        XCTAssert(orderId.exists)
        
        let dob = fullDetailsCell.staticTexts["31 Jul 1995"]
        XCTAssert(dob.exists)
        
        let skill = fullDetailsCell.staticTexts["E3"]
        XCTAssert(skill.exists)
        
    }
    
    /**
     Test Participant Details with training Only
     */
    func test_T5S8_ParticipantWithTrainingOnlyInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0"]
        
        moveToParticipantPage(evApp: false)
        
        let tablesQuery = app.tables
        
        let fullDetailsCell = tablesQuery.cells.containing(.staticText, identifier: "trainging_only@test.com").firstMatch
        XCTAssert(fullDetailsCell.exists)
        
        let accessoryButton = fullDetailsCell.buttons["accessories"]
        XCTAssert(accessoryButton.exists)
        
        let signature = fullDetailsCell.buttons["signature"]
        XCTAssertFalse(signature.exists)
        
        let fullName = fullDetailsCell.staticTexts["UI TESTER3(GUEST)"]
        XCTAssert(fullName.exists)
        
        let userId = fullDetailsCell.staticTexts["#1003"]
        XCTAssert(userId.exists)
        
        let orderId = fullDetailsCell.staticTexts["#15153"]
        XCTAssert(orderId.exists)
        
        let dob = fullDetailsCell.staticTexts["07 Dec 1992"]
        XCTAssert(dob.exists)
        
        let skill = fullDetailsCell.staticTexts["GT1"]
        XCTAssert(skill.exists)
        
    }
    
    /**
     Test Participant Details with rentals only     */
    func test_T5S9_ParticipantWithRentalsOnlyInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0"]
        
        moveToParticipantPage(evApp: false)
        
        let tablesQuery = app.tables
        
        let fullDetailsCell = tablesQuery.cells.containing(.staticText, identifier: "rentals_only@test.com").firstMatch
        XCTAssert(fullDetailsCell.exists)
        
        let accessoryButton = fullDetailsCell.buttons["accessories"]
        XCTAssert(accessoryButton.exists)
        
        let signature = fullDetailsCell.buttons["signature"]
        XCTAssertFalse(signature.exists)
        
        let fullName = fullDetailsCell.staticTexts["UI TESTER4(GUEST)"]
        XCTAssert(fullName.exists)
        
        let userId = fullDetailsCell.staticTexts["#1004"]
        XCTAssert(userId.exists)
        
        let orderId = fullDetailsCell.staticTexts["#15182"]
        XCTAssert(orderId.exists)
        
        let dob = fullDetailsCell.staticTexts["13 Feb 1965"]
        XCTAssert(dob.exists)
        
        let skill = fullDetailsCell.staticTexts["E1"]
        XCTAssert(skill.exists)
        
    }
    
    /**
     Test Participant Details with no sign or accessories     */
    func test_T5S10_ParticipantWithNoSignNoAccessoriesInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0"]
        
        moveToParticipantPage(evApp: false)
        
        let tablesQuery = app.tables
        
        let fullDetailsCell = tablesQuery.cells.containing(.staticText, identifier: "nodetails@test.com").firstMatch
        XCTAssert(fullDetailsCell.exists)
        
        let accessoryButton = fullDetailsCell.buttons["accessories"]
        XCTAssertFalse(accessoryButton.exists)
        
        let signature = fullDetailsCell.buttons["signature"]
        XCTAssertFalse(signature.exists)
        
        let fullName = fullDetailsCell.staticTexts["UI TESTER5(GUEST)"]
        XCTAssert(fullName.exists)
        
        let userId = fullDetailsCell.staticTexts["#1005"]
        XCTAssert(userId.exists)
        
        let orderId = fullDetailsCell.staticTexts["#21182"]
        XCTAssert(orderId.exists)
        
        let dob = fullDetailsCell.staticTexts["13 Oct 1985"]
        XCTAssert(dob.exists)
        
        let skill = fullDetailsCell.staticTexts["E1"]
        XCTAssert(skill.exists)
        
    }
    
    /**
     Test Participant Details with no sign or accessories     */
    func test_T5S11_UpgradeSkillInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "has_trainings" : "0"]
        
        moveToParticipantPage()
        
        let tablesQuery = app.tables
        
        let fullDetailsCell = tablesQuery.cells.containing(.staticText, identifier: "nodetails@test.com").firstMatch
        XCTAssert(fullDetailsCell.exists)
        
        let upwardArrowButton = fullDetailsCell.buttons["upward arrow"]
        upwardArrowButton.tap()
        
        verifyPageTitle(title: "Upgrade Skill Level")
        let options =  app.tables["SelectionMenuTableView"]
        waitForElementToAppear(element: options)
        options/*@START_MENU_TOKEN@*/.staticTexts["E2"]/*[[".cells.staticTexts[\"E2\"]",".staticTexts[\"E2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
    }
    
    /**
     Test verify empty Events In EV
     */
    func test_T5S12_TestEmptyListInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "true" ]
        
        moveToParticipantPage(evApp: true)
        
        XCTAssertTrue(app.tables.firstMatch.cells.count == 0)
        verifyErrorViewIsShown()
        let message = "No participants found"
        XCTAssertTrue(app.staticTexts[message].exists)
    }
    
    /**
     Test verify empty Particiapnts In Moto
     */
    func test_T5S13_TestEmptyListInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "true" ]
        
        moveToParticipantPage(evApp: false)
        
        XCTAssertTrue(app.tables.firstMatch.cells.count == 0)
        verifyErrorViewIsShown()
        let message = "No participants found"
        XCTAssertTrue(app.staticTexts[message].exists)
    }
    
    /**
     Test search Particiapnts In Ev
     */
    func test_T5S14_TestSearchParticiapntListInEv(){
        
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "false" ]
        moveToParticipantPage(evApp: true)
        tapSearch()
        search(text: "UI Tester3")
        XCTAssertTrue(app.tables.cells.count == 1)
        
        search(text: "No User")
        XCTAssertTrue(app.tables.cells.count == 0)
        
        let emptyResult = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH %@", "Sorry, we")).firstMatch
        XCTAssertTrue(emptyResult.exists)
        
    }
    /**
     Test search empty Particiapnts In Ev
     */
    func test_T5S15_TestSearchEmptyParticiapntListInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "true" ]
        
        moveToParticipantPage(evApp: true)
        
        XCTAssertTrue(app.tables.firstMatch.cells.count == 0)
        verifyErrorViewIsShown()
        
        tapSearch()
        
        let searchField = app.searchFields["Search participants here"]
        XCTAssertFalse(searchField.exists)
        
        
    }
    
    /**
     Test search Particiapnts In Moto
     */
    func test_T5S16_TestSearchParticiapntListInMoto(){
        
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "false" ]
        moveToParticipantPage(evApp: false)
        tapSearch()
        search(text: "UI Tester3")
        XCTAssertTrue(app.tables.cells.count == 1)
        
        search(text: "No User")
        XCTAssertTrue(app.tables.cells.count == 0)
        
        let emptyResult = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH %@", "Sorry, we")).firstMatch
        XCTAssertTrue(emptyResult.exists)
        
    }
    /**
     Test search empty Particiapnts In Moto
     */
    func test_T5S17_TestSearchEmptyParticiapntListInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "true" ]
        
        moveToParticipantPage(evApp: false)
        
        XCTAssertTrue(app.tables.firstMatch.cells.count == 0)
        verifyErrorViewIsShown()
        
        tapSearch()
        
        let searchField = app.searchFields["Search participants here"]
        XCTAssertFalse(searchField.exists)
        
        
    }
    
    /**
     Test Filter Particiapnts In Ev
     */
    func test_T5S18_TestFilterBySkillLevelParticiapntListInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "false" ]
        moveToParticipantPage()
        
        
        tapFilter()
        
        selectFilterType(type: "By Skill Level")
        selectFilter(option: "E1")
        
        XCTAssertTrue(app.tables.cells.count == 2)
        
        
    }
    
    /**
     Test Filter Particiapnts In Ev
     */
    func test_T5S19_TestFilterBySkillLevelParticiapntListInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "false" ]
        moveToParticipantPage(evApp: false)
        
        
        tapFilter()
        
        selectFilterType(type: "By Skill Level")
        selectFilter(option: "E1")
        
        XCTAssertTrue(app.tables.cells.count == 2)
        
        
    }
    /**
     Test Filter Particiapnts when empty In Ev
     */
    func test_T5S20_TestFilterInEmptyParticiapntListInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "true" ]
        moveToParticipantPage()
        
        tapFilter()
        
        let filterAlert =  app.alerts["Select Filter"]
        XCTAssertFalse(filterAlert.exists)
        
        
    }
    
    /**
     Test Filter Particiapnts when empty In Moto
     */
    func test_T5S21_TestFilterInEmptyParticiapntListInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "true" ]
        moveToParticipantPage(evApp: false)
        
        tapFilter()
        
        let filterAlert =  app.alerts["Select Filter"]
        XCTAssertFalse(filterAlert.exists)
        
        
    }
    /**
     Test Filter Particiapnts By Training In Ev
     */
    func test_T5S22_TestFilterByTrainingParticiapntListInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "false" ]
        moveToParticipantPage()
        
        tapFilter()
        selectFilterType(type: "By Training")
        selectFilter(option: "Training 2")
        
        XCTAssertTrue(app.tables.cells.count == 2)
        
        tapFilter()
        selectFilterType(type: "By Training")
        selectFilter(option: "Training 4")
        
        XCTAssertTrue(app.tables.cells.count == 1)
        
        
    }
    
    /**
     Test Filter Particiapnts By Rental In Ev
     */
    func test_T5S23_TestFilterByRentalsParticiapntListInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "false" ]
        moveToParticipantPage()
        
        tapFilter()
        selectFilterType(type: "By Rentals")
        selectFilter(option: "Gloves")
        
        XCTAssertTrue(app.tables.cells.count == 1)
        
        tapFilter()
        selectFilterType(type: "By Rentals")
        selectFilter(option: "Boots")
        
        XCTAssertTrue(app.tables.cells.count == 2)
        
    }
    /**
     Test Filter Particiapnts By Rental In Ev
     */
    func test_T5S24_TestFilterByTrainingNotAvailableWhenParticiapntsHaveNoTrainingsInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "false","participants_no_training":"true" ]
        moveToParticipantPage()
        
        tapFilter()
        verifyFilterTypeNotExists(type: "By Trainings")
        
    }
    /**
     Test Filter Particiapnts By Rental In Ev
     */
    func test_T5S25_TestFilterByRentalsNotAvailableWhenParticiapntsHaveNoRentalsInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "false","participants_no_rentals":"true" ]
        moveToParticipantPage()
        
        tapFilter()
        verifyFilterTypeNotExists(type: "By Rentals")
    }
    /**
     Test Filter Particiapnts By Rental In Ev
     */
    func test_T5S26_TestFilterByRentalsNotAvailableWhenParticiapntsHaveNoAccessoriesInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "false","participants_no_accessories":"true" ]
        moveToParticipantPage()
        
        tapFilter()
        verifyFilterTypeNotExists(type: "By Rentals")
        verifyFilterTypeNotExists(type: "By Trainings")
        
    }
    
    
    /**
     Test Filter Particiapnts By Rental In Ev
     */
    func test_T5S27_TestFilterByTrainingNotAvailableWhenParticiapntsHaveNoTrainingsInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "false","participants_no_training":"true" ]
        moveToParticipantPage()
        
        tapFilter()
        verifyFilterTypeNotExists(type: "By Trainings")
        
    }
    /**
     Test Filter Particiapnts By Rental In Ev
     */
    func test_T5S28_TestFilterByRentalsNotAvailableWhenParticiapntsHaveNoRentalsInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "false","participants_no_rentals":"true" ]
        moveToParticipantPage()
        
        tapFilter()
        verifyFilterTypeNotExists(type: "By Rentals")
        
        
        
    }
    /**
     Test Filter Particiapnts By Rental In Ev
     */
    func test_T5S29_TestFilterByRentalsNotAvailableWhenParticiapntsHaveNoAccessoriesInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "false","participants_no_accessories":"true" ]
        moveToParticipantPage()
        
        tapFilter()
        verifyFilterTypeNotExists(type: "By Rentals")
        verifyFilterTypeNotExists(type: "By Trainings")
        
    }
    
    /**
     Test Filter Particiapnts By Rental In Ev
     */
    func test_T5S30_TestFilterNotAvailableForParticiapntsWithNoFilterable(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "false","no_filter":"true" ]
        moveToParticipantPage()
        
        tapFilter()
        let filterAlert =  app.alerts["Select Filter"]
        XCTAssertFalse(filterAlert.exists)
        
        
    }
    
    /**
     Test Filter Particiapnts By Rental In Ev
     */
    func test_T5S31_TestFilterNotAvailableForParticiapntsWithNoFilterableInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin", "empty_event_participants" : "false","no_filter":"true" ]
        moveToParticipantPage(evApp: false)
        
        tapFilter()
        let filterAlert =  app.alerts["Select Filter"]
        XCTAssertFalse(filterAlert.exists)
        
    }
    
    /**
     Test Logout In Ev
     */
    func test_T5S32_TestLogoutInEv(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin" ]
        moveToParticipantPage()
        
        app.navigationBars["Events"].buttons["logout icon"].tap()
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        
        verifyLoginPage()
        
        
    }
    
    /**
     Test  Logout In Moto
     */
    func test_T5S33_TestLogoutInMoto(){
        testData = ["user_terms_agreed" : "true", "user_type": "admin" ]
        moveToParticipantPage(evApp: false)
        
        app.navigationBars["Events"].buttons["logout icon"].tap()
        
        verifyActivityIndicatorIsShown()
        waitForActivityIndicatorToDisAppear()
        
        verifyLoginPage()
        
    }
    
    private func verifyAccessoriesAlert(appMode: Bool, hasTrainings: Bool, hasRentals: Bool){
        
        testData = ["user_terms_agreed" : "true", "user_type": "admin" ]
        moveToParticipantPage(evApp: appMode)
        
        let tablesQuery = app.tables
        
        var itemCell = tablesQuery.cells.containing(.staticText, identifier: "nodetails@test.com").firstMatch
        
        
        if hasTrainings && hasRentals{
            itemCell = tablesQuery.cells.containing(.staticText, identifier: "fulldetails@test.com").firstMatch
        }else if hasRentals{
            itemCell = tablesQuery.cells.containing(.staticText, identifier: "rentals_only@test.com").firstMatch
        }else if hasTrainings{
            itemCell = tablesQuery.cells.containing(.staticText, identifier: "trainging_only@test.com").firstMatch
            
        }
        
        let starButton = itemCell.buttons["accessories"]
        if hasTrainings || hasRentals{
            starButton.tap()
        }else{
            XCTAssertFalse(starButton.exists)
            return
        }
        
        
        let accessoriesPage = app.staticTexts["Accessories"]
        waitForElementToAppear(element: accessoriesPage)
        
        if hasTrainings{
            let trainingText = tablesQuery.staticTexts["Trainings"]
            XCTAssertTrue(trainingText.exists)
        }
        if hasRentals{
            let trainingText = tablesQuery.staticTexts["Rentals"]
            XCTAssertTrue(trainingText.exists)
        }
        
        app.buttons["OK"].tap()
    }
    
    func test_T5S34_TestAccessoriesWhenNoAccessoriesPresentInEv(){
        verifyAccessoriesAlert(appMode: true, hasTrainings: false, hasRentals: false)
    }
    
    func test_T5S35_TestAccessoriesWhenTrainingOnlyPresentInEv(){
        verifyAccessoriesAlert(appMode: true, hasTrainings: true, hasRentals: false)
    }
    func test_T5S36_TestAccessoriesWhenRentalsOnlyPresentInEv(){
        verifyAccessoriesAlert(appMode: true, hasTrainings: false, hasRentals: true)
    }
    func test_T5S37_TestAccessoriesWhenAccessoriesPresentInEv(){
        verifyAccessoriesAlert(appMode: true, hasTrainings: true, hasRentals: true)
    }
    
    func test_T5S38_TestAccessoriesWhenNoAccessoriesPresentInMoto(){
        verifyAccessoriesAlert(appMode: false, hasTrainings: false, hasRentals: false)
    }
    
    func test_T5S39_TestAccessoriesWhenTrainingOnlyPresentInMoto(){
        verifyAccessoriesAlert(appMode: false, hasTrainings: true, hasRentals: false)
    }
    func test_T5S40_TestAccessoriesWhenRentalsOnlyPresentInMoto(){
        verifyAccessoriesAlert(appMode: false, hasTrainings: false, hasRentals: true)
    }
    func test_T5S41_TestAccessoriesWhenAccessoriesPresentInMoto(){
        verifyAccessoriesAlert(appMode: false, hasTrainings: true, hasRentals: true)
    }
    
   
}


