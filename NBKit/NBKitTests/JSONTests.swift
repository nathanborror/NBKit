//
//  JSONTests.swift
//  NBKitExample
//
//  Created by Nathan Borror on 9/11/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

import Foundation
import XCTest
import NBKit


class NBKitJSONTestCase: XCTestCase {

    func testJSONStringify() {
        let expected = "{\"name\":\"foo\"}"

        let dict = ["name": "foo"]
        XCTAssertEqual(JSON.stringify(dict), expected, "dictionary should be equal.")

        let nsdict = NSDictionary(objects: ["foo"], forKeys: ["name"])
        XCTAssertEqual(JSON.stringify(nsdict), expected, "nsdictionary should be equal.")

        let array = ["foo", "bar"]
        XCTAssertEqual(JSON.stringify(array), "[\"foo\",\"bar\"]", "array args should be equal.")

        let dictArray = [["name": "foo"], ["name": "bar"]]
        XCTAssertEqual(JSON.stringify(dictArray), "[{\"name\":\"foo\"},{\"name\":\"bar\"}]", "array of dictionaries should be equal.")
    }

    func testJSONArrayParsing() {
        let input = "[{\"name\":\"foo\"},{\"name\":\"bar\"}]"
        let data = (input as NSString).dataUsingEncoding(NSUTF8StringEncoding)

        XCTAssertNotNil(data, "isn't nil.")

        let parsed = JSON.parseArray(data!)

        XCTAssertNotNil(parsed, "isn't nil.")
        XCTAssertEqual(parsed!.count, 2, "has two items.")
    }

    func testJSONDictionaryParsing() {
        let input = "{\"name\":\"bar\"}"
        let data = (input as NSString).dataUsingEncoding(NSUTF8StringEncoding)

        XCTAssertNotNil(data, "isn't nil.")

        let parsed = JSON.parseDictionary(data!)

        XCTAssertNotNil(parsed, "isn't nil.")

        let name:AnyObject = parsed!["name"]!
        XCTAssertEqual(name as String, "bar", "has two items.")
    }

}