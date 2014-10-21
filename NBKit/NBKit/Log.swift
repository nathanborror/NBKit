//
//  Log.swift
//  NBKitExample
//
//  Created by Nathan Borror on 9/11/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

import Foundation

public class Log {

    public class func error(msg: AnyObject?) {
        println("<Error>: \(msg)")
    }

    public class func warn(msg: AnyObject?) {
        println("<Warning>: \(msg)")
    }

    public class func info(msg: AnyObject?) {
        println("<Info>: \(msg)")
    }

    public class func debug(msg: AnyObject?) {
        println("<Debug>: \(msg)")
    }

    public class func verbose(msg: AnyObject?) {
        println("<Verbose>: \(msg)")
    }

}