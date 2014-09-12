//
//  RequestTests.swift
//  NBKitExample
//
//  Created by Nathan Borror on 9/11/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

import Foundation
import XCTest
import NBKit

class NBKitRequestTestCase: XCTestCase {

    func testRequestClassMethod() {
        let url = "http://httpbin.org/get"
        let expectation = expectationWithDescription("\(url)")

        Request.Get(url, completion: { (data, response, error) -> Void in
            expectation.fulfill()

            XCTAssertNotNil(data, "response should not be nil")
            XCTAssertNil(error, "error should not be nil")

            let obj = JSON.parseDictionary(data!)

            XCTAssertNotNil(obj, "parsed json should not be nil")
//            XCTAssertEqual(obj["url"] as String, url, "url should equal url")
        })

        waitForExpectationsWithTimeout(10) { error -> Void in
            XCTAssertNil(error, "\(error)")
        }
    }
}