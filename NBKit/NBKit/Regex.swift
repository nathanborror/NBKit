//
//  Regex.swift
//  NBKit
//
//  Created by Nathan Borror on 9/26/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//
// Inspired by: http://benscheirman.com/2014/06/regex-in-swift/
//

import Foundation

class Regex {

    let pattern:String
    let expression:NSRegularExpression

    init(_ pattern:String, options:NSRegularExpressionOptions) {
        self.pattern = pattern

        var error:NSError?
        self.expression = NSRegularExpression(pattern: self.pattern, options: options, error: &error)!
    }

    convenience init(pattern:String) {
        self.init(pattern, options: NSRegularExpressionOptions.CaseInsensitive)
    }

    func replace(input:String, with:String) -> String {
        return self.expression.stringByReplacingMatchesInString(input, options: NSMatchingOptions(0), range: NSMakeRange(0, count(input)), withTemplate: with)
    }

    func test(input:String?) -> Bool {
        if input != nil {
            let matches = self.expression.matchesInString(input!, options: NSMatchingOptions(0), range: NSMakeRange(0, count(input!)))
            return matches.count > 0
        }
        return false
    }

    func match(input: String?) -> [NSTextCheckingResult] {
        if let str = input {
            let range = NSRange(location: 0, length: count(str))
            return self.expression.matchesInString(str, options: NSMatchingOptions(0), range: range) as! [NSTextCheckingResult]
        }
        return [NSTextCheckingResult]()
    }

}

infix operator =~ {}

func =~ (input:String?, pattern:String) -> Bool {
    if input != nil {
        return Regex(pattern: pattern).test(input!)
    }
    return false
}
