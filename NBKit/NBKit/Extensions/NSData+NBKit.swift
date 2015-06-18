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

    public class func loadAsync(url:String, completion:(NSData?, ErrorType?) -> Void) {
        guard let url = NSURL(string: url) else { return }

        // Check the cache to see if the item already exists
        guard let data = Cache.shared.get(url.absoluteString) as? NSData else {
            // TODO: Guard against multiple requests for the same url
            let queue = dispatch_queue_create("NSData.loadAsyncQueue", nil)
            dispatch_async(queue, { () -> Void in
                do {
                    let data = try NSData(contentsOfURL: url, options: NSDataReadingOptions(rawValue: 0))
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        Cache.shared.set(url.absoluteString, obj: data)
                        completion(data, nil)
                    })
                } catch {
                    completion(nil, error)
                    return
                }
            })
            return
        }

        completion(data, nil)
    }

}