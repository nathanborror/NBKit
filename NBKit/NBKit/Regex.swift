/*
    Regex.swift
    NBKit

    Created by Nathan Borror on 9/26/14.
    Copyright (c) 2014 Nathan Borror. All rights reserved.

    Abstract:
        The `Regex` class provides convenient ways for working with regular
        expressions. Inspired by: http://benscheirman.com/2014/06/regex-in-swift/
*/

import Foundation

public class Regex {

    let pattern:String
    var expression:NSRegularExpression?

    public init(pattern:String, options:NSRegularExpressionOptions = NSRegularExpressionOptions.CaseInsensitive) throws {
        self.pattern = pattern

        do {
            self.expression = try NSRegularExpression(pattern: self.pattern, options: options)
        } catch {
            throw(error)
        }
    }

    public func replace(input:String, with:String) -> String {
        let range = NSMakeRange(0, input.characters.count)
        guard let result = self.expression?.stringByReplacingMatchesInString(input, options: NSMatchingOptions(rawValue: 0), range: range, withTemplate: with) else {
            return ""
        }
        return result
    }

    public func test(input:String?) -> Bool {
        guard let str = input else {
            return false
        }

        let range = NSMakeRange(0, str.characters.count)
        guard let matches = self.expression?.matchesInString(str, options: NSMatchingOptions(rawValue: 0), range: range) else {
            return false
        }

        return matches.count > 0
    }

    public func match(input: String?) -> [NSTextCheckingResult] {
        guard let str = input else {
            return [NSTextCheckingResult]()
        }

        let range = NSRange(location: 0, length: str.characters.count)
        guard let matches = self.expression?.matchesInString(str, options: NSMatchingOptions(rawValue: 0), range: range) else {
            return [NSTextCheckingResult]()
        }

        return matches
    }

}

infix operator =~ {}

public func =~ (input:String?, pattern:String) throws -> Bool {
    if input != nil {
        return try Regex(pattern: pattern).test(input!)
    }
    return false
}
