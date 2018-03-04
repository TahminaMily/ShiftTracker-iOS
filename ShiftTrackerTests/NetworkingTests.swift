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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testGetBusiness() {
        let expectation = XCTestExpectation(description: "Fetch Business Info")
        
        
        Alamofire.request(APIRouter.business).responseObject { (response: DataResponse<Business>) in
            print(response.value as Any)
            XCTAssertNotNil(response.value)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
}
