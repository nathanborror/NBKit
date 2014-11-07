//
//  Parser.swift
//  NBKit
//
//  Created by Chris Eidhof (http://chris.eidhof.nl/posts/json-parsing-in-swift.html)
//  Modified by Nathan Borror on 9/1/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

import Foundation

func asDict(x: AnyObject) -> [String:AnyObject]? {
    return x as? [String:AnyObject]
}

func join<A> (elements: [A?]) -> [A]? {
    var result: [A] = []
    for element in elements {
        if let x = element {
            result += [x]
        } else {
            return nil
        }
    }
    return result
}

infix operator <*> { associativity left precedence 150 }

func <*><A, B> (l: (A -> B)?, r: A?) -> B? {
    if let l1 = l {
        if let r1 = r {
            return l1(r1)
        }
    }
    return nil
}

func flatten<A> (x: A??) -> A? {
    if let y = x { return y }
    return nil
}

func array(input: [String:AnyObject], key: String) -> [AnyObject]? {
    let maybeAny: AnyObject? = input[key]
    return maybeAny >>>= { $0 as? [AnyObject] }
}

func dictionary(input: [String: AnyObject], key: String) -> [String: AnyObject]? {
    return input[key] >>>= { $0 as? [String: AnyObject] }
}

func string(input: [String:AnyObject], key: String) -> String? {
    return input[key] >>>= { $0 as? String }
}

func number(input: [NSObject:AnyObject], key: String) -> NSNumber? {
    return input[key] >>>= { $0 as? NSNumber }
}

func int(input: [NSObject:AnyObject], key: String) -> Int? {
    return number(input, key).map { $0.integerValue }
}

func bool(input: [NSObject:AnyObject], key: String) -> Bool? {
    return number(input, key).map { $0.boolValue }
}

func curry<A,R>(fn: (A) -> R) -> A -> R {
    return { a in fn(a) }
}

func curry<A,B,R>(fn: (A,B) -> R) -> A -> B -> R {
    return { a in { b in fn(a,b) } }
}

func curry<A,B,C,R>(fn: (A,B,C) -> R) -> A -> B -> C -> R {
    return { a in { b in { c in fn(a,b,c) } } }
}

func curry<A,B,C,D,R>(fn: (A,B,C,D) -> R) -> A -> B -> C -> D -> R {
    return { a in { b in { c in { d in fn(a,b,c,d) } } } }
}

func curry<A,B,C,D,E,R>(fn: (A,B,C,D,E) -> R) -> A -> B -> C -> D -> E -> R {
    return { a in { b in { c in { d in { e in fn(a,b,c,d,e) } } } } }
}

func curry<A,B,C,D,E,F,R>(fn: (A,B,C,D,E,F) -> R) -> A -> B -> C -> D -> E -> F -> R {
    return { a in { b in { c in { d in { e in { f in fn(a,b,c,d,e,f) } } } } } }
}

func curry<A,B,C,D,E,F,G,R>(fn: (A,B,C,D,E,F,G) -> R) -> A -> B -> C -> D -> E -> F -> G -> R {
    return { a in { b in { c in { d in { e in { f in { g in fn(a,b,c,d,e,f,g) } } } } } } }
}

func curry<A,B,C,D,E,F,G,H,R>(fn: (A,B,C,D,E,F,G,H) -> R) -> A -> B -> C -> D -> E -> F -> G -> H -> R {
    return { a in { b in { c in { d in { e in { f in { g in { h in fn(a,b,c,d,e,f,g,h) } } } } } } } }
}

func curry<A,B,C,D,E,F,G,H,I,R>(fn: (A,B,C,D,E,F,G,H,I) -> R) -> A -> B -> C -> D -> E -> F -> G -> H -> I -> R {
    return { a in { b in { c in { d in { e in { f in { g in { h in { i in fn(a,b,c,d,e,f,g,h,i) } } } } } } } } }
}

infix operator >>>= {}

func >>>=<A,B> (optional: A?, f: A->B?) -> B? {
    return flatten(optional.map(f))
}
