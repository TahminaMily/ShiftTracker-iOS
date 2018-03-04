//
//  NetworkingTests.swift
//  ShiftTrackerTests
//
//  Created by Tahmina Khanam on 4/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import XCTest
import Alamofire
@testable import ShiftTracker

class NetworkingTests: XCTestCase {
    
    let username = "SteveJobs"
    let timeout = 30.0
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetBusiness() {
        let expectation = XCTestExpectation(description: "Fetch Business Info")
        
        Alamofire.request(APIRouter.business).responseObject { (response: DataResponse<Business>) in
            print(response.value as Any)
            XCTAssertNotNil(response.value)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
    }
    
    func testGetShifts() {
        let expectation = XCTestExpectation(description: "Fetch Shift list")
        let sessionManager = APIRouter.sessionManager
        sessionManager.adapter = DeputyAuthAdapter(username: username)
        
        sessionManager.request(APIRouter.shifts).responseObject { (response: DataResponse<[Shift]>) in
            print(response.value as Any)
            XCTAssertNotNil(response.value)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
    }
    
    func testStartShift() {
        let expectation = XCTestExpectation(description: "Start shift")
        let sessionManager = APIRouter.sessionManager
        sessionManager.adapter = DeputyAuthAdapter(username: username)
        
        sessionManager
            .request(APIRouter.shiftStart(event: Shift.Event(time: Date(), latitude: 0.1, longitude: 0.1)))
            .responseData { (response) in
                print(response as Any)
                XCTAssertNotNil(response.value)
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
    }
    
    func testEndShift() {
        let expectation = XCTestExpectation(description: "End Shift")
        let sessionManager = APIRouter.sessionManager
        sessionManager.adapter = DeputyAuthAdapter(username: username)
        
        sessionManager
            .request(APIRouter.shiftEnd(event: Shift.Event(time: Date(), latitude: 0.1, longitude: 0.1)))
            .responseData { (response) in
                print(response as Any)
                XCTAssertNotNil(response.value)
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
    }
    
}
