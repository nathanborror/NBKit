//
//  JSON.swift
//  NBKit
//
//  Created by Nathan Borror on 8/26/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//
//  Heavily inspired by: https://github.com/subdigital/nsscreencast
//

import Foundation

enum JSValue: Printable {
    case JSArray([JSValue])
    case JSObject([String:JSValue])
    case JSString(String)
    case JSNumber(Double)
    case JSBool(Bool)
    case JSNull()

    static func decode(data:NSData) -> JSValue? {
        var error:NSError?
        let options = NSJSONReadingOptions.AllowFragments
        if let json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: options, error: &error) {
            return make(json as! NSObject)
        }

        println("Couldn't parse privided JSON")
        return nil
    }

    static func make(obj:NSObject) -> JSValue {
        switch obj {
        case let a as NSArray:
            return makeArray(a)
        case let d as NSDictionary:
            return makeObject(d)
        case let s as NSString:
            return .JSString(s as! String)
        case let n as NSNumber:
            return .JSNumber(n.doubleValue)
        case let b as Bool:
            return .JSBool(b)
        case let null as NSNull:
            return .JSNull()
        default:
            println("Unhandled type <\(obj)>")
            abort()
        }
    }

    static func makeArray(array:NSArray) -> JSValue {
        var items = [JSValue]()
        for obj in array {
            let value = make(obj as! NSObject)
            items.append(value)
        }
        return .JSArray(items)
    }

    static func makeObject(dict:NSDictionary) -> JSValue {
        var obj = [String:JSValue]()
        for (key,value) in dict {
            obj[key as! String] = make(value as! NSObject)
        }
        return .JSObject(obj)
    }

    var description:String {
        get {
            switch self {
            case let .JSArray(a):
                return "JSArray(\(a))"
            case let .JSObject(o):
                return "JSObject(\(o))"
            case let .JSString(s):
                return "JSString(\(s))"
            case let .JSNumber(n):
                return "JSNumber(\(n))"
            case let .JSBool(b):
                return "JSBool(\(b))"
            case let .JSNull():
                return "JSNull()"
            }
        }
    }
}

// MARK: JSON Decoding

protocol JSONDecode {
    typealias J
    class func fromJSON(j:JSValue) -> J?
}

class JSArray<A,B:JSONDecode where B.J == A>: JSONDecode {
    typealias J = [A]
    class func fromJSON(j:JSValue) -> J? {
        switch j {
        case .JSArray(let array):
            let mapped = array.map { B.fromJSON($0) }
            let results = compact(mapped)
            if results.count == mapped.count {
                return results
            }
            return nil
        default:
            return nil
        }
    }
}

class JSObject: JSONDecode {
    typealias J = [String: JSValue]
    class func fromJSON(j:JSValue) -> J? {
        switch j {
        case .JSObject(let s):
            return s as J
        default:
            return nil
        }
    }
}

class JSString: JSONDecode {
    typealias J = String
    class func fromJSON(j:JSValue) -> J? {
        switch j {
        case .JSString(let s):
            return s
        default:
            return nil
        }
    }
}

class JSInt: JSONDecode {
    typealias J = Int
    class func fromJSON(j:JSValue) -> J? {
        switch j {
        case .JSNumber(let n):
            return Int(n)
        default:
            return nil
        }
    }
}

class JSDouble: JSONDecode {
    typealias J = Double
    class func fromJSON(j: JSValue) -> J? {
        switch j {
        case .JSNumber(let d):
            return Double(d)
        default:
            return nil
        }
    }
}

class JSBool: JSONDecode {
    typealias J = Bool
    class func fromJSON(j:JSValue) -> J? {
        switch j {
        case .JSBool(let n):
            return Bool(n)
        default:
            return nil
        }
    }
}

class JSURL: JSONDecode {
    typealias J = NSURL
    class func fromJSON(j:JSValue) -> NSURL? {
        switch j {
        case .JSString(let s):
            return NSURL(string: s)
        default:
            return nil
        }
    }
}

class JSTimeInterval: JSONDecode {
    typealias J = NSTimeInterval
    class func fromJSON(j: JSValue) -> J? {
        switch j {
        case .JSNumber(let n):
            return NSTimeInterval(n)
        default:
            return nil
        }
    }
}

// MARK: Functions

func compact<T>(collection:[T?]) -> [T] {
    return filter(collection) {
        if $0 != nil {
            return true
        }
        return false
    }.map { $0! }
}

// MARK: Operators

infix operator >>> {
    associativity left
    precedence 150
}

func >>> <A,B> (source: A?, f:A -> B?) -> B? {
    if source != nil {
        return f(source!)
    }
    return nil
}
