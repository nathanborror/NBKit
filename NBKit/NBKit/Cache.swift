//
//  Cache.swift
//  Streams
//
//  Created by Nathan Borror on 11/4/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

import Foundation

class Cache {

    class var shared:Cache {
        struct Static {
            static let instance:Cache = Cache()
        }
        return Static.instance
    }

    private var cache = NSCache()

    func get(key:String) -> AnyObject? {
        return cache.objectForKey(key)
    }

    func set(key:String, obj:AnyObject) -> AnyObject {
        cache.setObject(obj, forKey: key)
        return obj
    }

}