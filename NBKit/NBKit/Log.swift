//
//  Log.swift
//  NBKitExample
//
//  Created by Nathan Borror on 9/11/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

import Foundation

public class Log {

    public class func error(msg: String) {
        println("<Error>: \(msg)")
    }

    public class func warn(msg: String) {
        println("<Warning>: \(msg)")
    }

    public class func info(msg: String) {
        println("<Info>: \(msg)")
    }

    public class func debug(msg: String) {
        println("<Debug>: \(msg)")
    }

    public class func verbose(msg: String) {
        println("<Verbose>: \(msg)")
    }

}