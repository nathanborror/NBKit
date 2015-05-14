/*
    JSON.swift
    NBKit

    Created by Nathan Borror on 8/26/14.
    Copyright (c) 2014 Nathan Borror. All rights reserved.

    Abstract:
        The `JSON` class offers a simpler way to parse json. Heavily 
        inspired by: https://github.com/subdigital/nsscreencast
*/

import Foundation

public enum JSValue: Printable {
    case JSArray([JSValue])
    case JSObject([String:JSValue])
    case JSString(String)
    case JSNumber(Double)
    case JSBool(Bool)
    case JSNull()

    public static func decode(data:NSData) -> JSValue? {
        var error:NSError?
        let options = NSJSONReadingOptions.AllowFragments
        if let json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: options, error: &error) {
            return make(json as! NSObject)
        }

        println("Couldn't parse privided JSON")
        return nil
    }

    public static func make(obj:NSObject) -> JSValue {
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

    public static func makeArray(array:NSArray) -> JSValue {
        var items = [JSValue]()
        for obj in array {
            let value = make(obj as! NSObject)
            items.append(value)
        }
        return .JSArray(items)
    }

    public static func makeObject(dict:NSDictionary) -> JSValue {
        var obj = [String:JSValue]()
        for (key,value) in dict {
            obj[key as! String] = make(value as! NSObject)
        }
        return .JSObject(obj)
    }

    public var description:String {
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

public protocol JSONDecode {
    typealias J
    static func fromJSON(j:JSValue) -> J?
}

public class JSArray<A,B:JSONDecode where B.J == A>: JSONDecode {
    public typealias J = [A]
    public class func fromJSON(j:JSValue) -> J? {
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

public class JSObject: JSONDecode {
    public typealias J = [String: JSValue]
    public class func fromJSON(j:JSValue) -> J? {
        switch j {
        case .JSObject(let s):
            return s as J
        default:
            return nil
        }
    }
}

public class JSString: JSONDecode {
    public typealias J = String
    public class func fromJSON(j:JSValue) -> J? {
        switch j {
        case .JSString(let s):
            return s
        default:
            return nil
        }
    }
}

public class JSInt: JSONDecode {
    public typealias J = Int
    public class func fromJSON(j:JSValue) -> J? {
        switch j {
        case .JSNumber(let n):
            return Int(n)
        default:
            return nil
        }
    }
}

public class JSDouble: JSONDecode {
    public typealias J = Double
    public class func fromJSON(j: JSValue) -> J? {
        switch j {
        case .JSNumber(let d):
            return Double(d)
        default:
            return nil
        }
    }
}

public class JSBool: JSONDecode {
    public typealias J = Bool
    public class func fromJSON(j:JSValue) -> J? {
        switch j {
        case .JSBool(let n):
            return Bool(n)
        default:
            return nil
        }
    }
}

public class JSURL: JSONDecode {
    public typealias J = NSURL
    public class func fromJSON(j:JSValue) -> NSURL? {
        switch j {
        case .JSString(let s):
            return NSURL(string: s)
        default:
            return nil
        }
    }
}

public class JSTimeInterval: JSONDecode {
    public typealias J = NSTimeInterval
    public class func fromJSON(j: JSValue) -> J? {
        switch j {
        case .JSNumber(let n):
            return NSTimeInterval(n)
        default:
            return nil
        }
    }
}

// MARK: Functions

public func compact<T>(collection:[T?]) -> [T] {
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

public func >>> <A,B> (source: A?, f:A -> B?) -> B? {
    if source != nil {
        return f(source!)
    }
    return nil
}
