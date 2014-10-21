//
//  JSON.swift
//  NBKit
//
//  Created by Nathan Borror on 8/26/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

import Foundation

/// Helper methods for parsing JSON using NSJSONSerialization.
public class JSON {

    /**
        Returns a string of json output.

        :param: obj An object to be converted into a JSON string.
        :returns: A String representing a JSON object.
    */
    public class func stringify(obj: AnyObject) -> String {
        var err: NSError?
        let data = NSJSONSerialization.dataWithJSONObject(obj, options: NSJSONWritingOptions(0), error: &err)
        if err != nil {
            return ""
        }

        return NSString(data: data!, encoding: NSUTF8StringEncoding)!
    }

    /**
        Returns an array of generic objects when given a string that represents
        a JSON array.

        :param: data An NSData object to be parsed.
        :returns: A list of generic objects representing the JSON string.
    */
    public class func parseArray(data: NSData) -> [AnyObject]? {
        if data.length > 0 {
            var err: NSError?
            var obj = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &err) as [AnyObject]
            return obj
        }
        return nil
    }

    /**
        Returns a dictionary of string/generic object pairs given a string that 
        represents a JSON object.

        :param: data An NSData object to be parsed.
        :returns: An optional dictionary of string/generic object pairs.
    */
    public class func parseDictionary(data: NSData) -> [String: AnyObject]? {
        if data.length > 0 {
            var err: NSError?
            let obj = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &err) as [String: AnyObject]
            return obj
        }
        return nil
    }

}