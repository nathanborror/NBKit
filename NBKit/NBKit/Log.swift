/*
    Log.swift
    NBKit

    Created by Nathan Borror on 9/11/14.
    Copyright (c) 2014 Nathan Borror. All rights reserved.

    Abstract:
        The `Log` class provides convient ways to log things.
*/

import Foundation

public enum LogLevel {
    case Debug
    case Info
    case Warn
    case Error
    case Verbose

    public func description() -> String {
        switch self {
        case .Debug:    return "[Debug]"
        case .Info:     return "[Info]"
        case .Warn:     return "[Warn]"
        case .Error:    return "[Error]"
        case .Verbose:  return "[Verbose]"
        }
    }
}

public class Log {

    public init<T>(_ level:LogLevel, message:T?) {
        if message is String {
            println("\(level.description()): \(message!)")
            return
        }
        println("\(level.description()): \(message)")
    }

    public class func error<T>(message: T?) {
        Log(.Error, message: message)
    }

    public class func warn<T>(message: T?) {
        Log(.Warn, message: message)
    }

    public class func info<T>(message: T?) {
        Log(.Info, message: message)
    }

    public class func debug<T>(message: T?) {
        Log(.Debug, message: message)
    }

    public class func verbose<T>(message: T?) {
        Log(.Verbose, message: message)
    }
    
}
