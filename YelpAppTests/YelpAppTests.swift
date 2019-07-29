//
//  YelpAppTests.swift
//  YelpAppTests
//
//  Created by Masoud Soleimani on 2019-07-29.
//  Copyright © 2019 Mas One. All rights reserved.
//

import XCTest
@testable import YelpApp

class YelpAppTests: XCTestCase {
    
    let services = APIService()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testBusinessSearch() {
        let expectation = self.expectation(description: "done")
        services.fetchRestaurant(keyword: nil, lat: "43.6532", long: "-79.3832") { (result, error) in
            if let model = result as? RestaurantModel, let businesses=model.businesses, businesses.count>0 {
                XCTAssert(true)
            } else {
                XCTAssert(false)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }

}
