//
//  EngagementUITests.swift
//  EngagementUITests
//
//  Created by Microsoft on 08/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import XCTest

class EngagementUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCollapse(){
        
        let app = XCUIApplication()
        app.navigationBars["Engagement.HomeView"].children(matching: .button).element(boundBy: 0).tap()
        
        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText, identifier:"Helpful links").children(matching: .staticText).matching(identifier: "Helpful links").element(boundBy: 0).tap()
        tablesQuery.staticTexts["Helpful links"].tap()
        
    }
    
    func testVideos() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.navigationBars["Engagement.HomeView"].children(matching: .button).element(boundBy: 0).tap()
        
        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText, identifier:"Videos").children(matching: .staticText).matching(identifier: "Videos").element(boundBy: 0).tap()
        // Failed to find matching element please file bug (bugreport.apple.com) and provide output from Console.app
        tablesQuery.cells.containing(.staticText, identifier:"Capturing Analytics data with Azure Mobile Engagement").children(matching: .staticText).matching(identifier: "Capturing Analytics data with Azure Mobile Engagement").element(boundBy: 0).tap()
        
    }
    
}
