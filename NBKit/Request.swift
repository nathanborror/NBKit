//
//  Request.swift
//  NBKit
//
//  Created by Nathan Borror on 9/1/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

import Foundation


/// A basic HTTP request handler that wraps NSURLSession.
class Request {

    /**
        Request methods.

        - CONNECT: 
        - DELETE: 
        - GET: 
        - HEAD:
        - OPTIONS:
        - PATCH:
        - POST: 
        - PUT: 
        - TRACE: 
        - SUBSCRIBE: Used to request current state and state updates from a 
            remote node. (Session Initiation Protocol RFC 6665)
        - NOTIFY: Sent to inform subscribers of changes in state to which the
            subscriber has a subscription.
    */
    enum RequestsMethod: String {
        case CONNECT = "CONNECT"
        case DELETE = "DELETE"
        case GET = "GET"
        case HEAD = "HEAD"
        case OPTIONS = "OPTIONS"
        case PATCH = "PATCH"
        case POST = "POST"
        case PUT = "PUT"
        case TRACE = "TRACE"
        case SUBSCRIBE = "SUBSCRIBE"
        case NOTIFY = "NOTIFY"
    }

    /**
        A Request makes a simple HTTP request and uses a completion closure to
        return the requests optional NSData, NSURLResponse, and NSError.

        :param: method The type of HTTP method (GET, POST, DELETE etc.).
        :param: url The full url string
        :param: body Optional body string
        :param: headers Optional key/value pairs of strings
        :param: completion The completion handler to call when the load request
            is complete.
     */
    init(method: RequestsMethod, url: String, body: String?, headers: [String: String]?, completion: ((NSData!, NSURLResponse!, NSError!) -> Void)?) {
        var request = NSMutableURLRequest(URL: NSURL(string: url))
        request.HTTPMethod = method.toRaw()

        if body != nil {
            request.HTTPBody = body!.dataUsingEncoding(NSUTF8StringEncoding)
        }

        if headers != nil {
            for (key, value) in headers! {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if error != nil {
                println("[Request Error]: \(error.localizedDescription)")
                return
            }

            dispatch_async(dispatch_get_main_queue(),{
                if let block = completion {
                    block(data, response, error)
                }
            })
        }).resume()
    }

    class func Get(url: String, completion: (NSData!, NSURLResponse!, NSError!) -> Void) {
        Request(method: .GET, url: url, body: nil, headers: nil, completion: completion)
    }

    class func Post(url: String, body: String, headers: [String: String], completion: ((NSData!, NSURLResponse!, NSError!) -> Void)?) {
        Request(method: .POST, url: url, body: body, headers: headers, completion: completion)
    }

    class func Put(url: String, body: String, headers: [String: String], completion: ((NSData!, NSURLResponse!, NSError!) -> Void)?) {
        Request(method: .PUT, url: url, body: body, headers: headers, completion: completion)
    }

    class func Delete(url: String, body: String, headers: [String: String], completion: ((NSData!, NSURLResponse!, NSError!) -> Void)?) {
        Request(method: .DELETE, url: url, body: body, headers: headers, completion: completion)
    }

    class func Subscribe(url: String, headers: [String: String], completion: ((NSData!, NSURLResponse!, NSError!) -> Void)?) {
        Request(method: .SUBSCRIBE, url: url, body: nil, headers: headers, completion: completion)
    }
}
