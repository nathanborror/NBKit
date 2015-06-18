/*
    NSDate.swift
    NBKit

    Created by Nathan Borror on 12/26/14.
    Copyright (c) 2014 Nathan Borror. All rights reserved.

    Abstract:
        The `NSDate` extension adds some convenient class methods for dealing
        with dates.
*/

import Foundation

extension NSDate {

    public class func parse(dateStr: String, format: String = "yyyy-MM-dd") -> NSDate {
        let dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = format
        return dateFmt.dateFromString(dateStr)!
    }

    public class func timesince(dateStr: String, format: String) -> String {
        let formatter = NSDateFormatter()
        formatter.formatterBehavior = NSDateFormatterBehavior.Behavior10_4
        formatter.dateFormat = format

        guard let date = formatter.dateFromString(dateStr) else {
            return "unknown"
        }

        return NSDate.timesince(date)
    }

    public class func timesince(date: NSDate) -> String {
        let today = NSDate()
        let since = date.timeIntervalSinceDate(today) * -1

        switch since {
        case 0...1:
            return "never"
        case 0...60:
            return "just now"
        case 0...3600: // 60 min
            let diff = Int(round(since/60))
            return "\(diff) minutes ago"
        case 0...86400: // 24 hr
            let diff = Int(round(since/60/60))
            return "\(diff) hours ago"
        case 0...2629743: // 1 day
            let diff = Int(round(since/60/60/24))
            return "\(diff) days ago"
        default:
            return "unknown"
        }
    }

    public class func from(unix: Double) -> NSDate {
        return NSDate(timeIntervalSince1970: unix)
    }

    public class func unix(date: NSDate = NSDate()) -> Double {
        return date.timeIntervalSince1970 as Double
    }
    
}
