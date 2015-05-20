/*
    NSData.swift
    NBKit

    Created by Nathan Borror on 11/4/14.
    Copyright (c) 2014 Nathan Borror. All rights reserved.

    Abstract:
        The `NSData` extension adds a loadAsync method for loading data
        in a background thread.
*/

import Foundation

extension NSData {

    public class func loadAsync(url:String, completion:(NSData?, NSError?) -> Void) {
        if let url = NSURL(string: url) {
            // Check the cache to see if the item already exists
            if let data = Cache.shared.get(url.absoluteString!) as? NSData {
                completion(data, nil)
                return
            }

            // TODO: Guard against multiple requests for the same url

            let queue = dispatch_queue_create("NSData.loadAsyncQueue", nil)
            dispatch_async(queue, { () -> Void in
                var error:NSError?
                let data = NSData(contentsOfURL: url, options: NSDataReadingOptions(0), error:&error)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if data != nil {
                        Cache.shared.set(url.absoluteString!, obj: data!)
                    }
                    completion(data, error)
                })
            })
        }
    }

}