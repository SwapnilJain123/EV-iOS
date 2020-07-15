//
//  Tests.swift
//  Tests
//
//  Created by Subair Ariyil on 13/07/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import XCTest
@testable import EvolveGT_QA

class Tests: XCTestCase {

    var user: User!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        user = User(id: "1", email: "test@testmail.com", firstName: "Ubit", lastName: "Tester", displayName: "Unit Tester", skillLevel: "E1", role: "Coach")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertFalse(user.isAdmin())
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
