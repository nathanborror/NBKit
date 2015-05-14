/*
    Cache.swift
    NBKit

    Created by Nathan Borror on 11/4/14.
    Copyright (c) 2014 Nathan Borror. All rights reserved.

    Abstract:
        The `Cache` singleton lets you store and retrieve items without
        instantiating NSCache every time.
*/

import Foundation

public class Cache {

    public class var shared:Cache {
        struct Static {
            static let instance:Cache = Cache()
        }
        return Static.instance
    }

    private var cache = NSCache()

    public func get(key:String) -> AnyObject? {
        return cache.objectForKey(key)
    }

    public func set(key:String, obj:AnyObject) -> AnyObject {
        cache.setObject(obj, forKey: key)
        return obj
    }

}