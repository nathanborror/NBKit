# NBKit

NBKit is a collection of tools to make prototyping iOS apps easier.

#### Cache.swift

Cache is a dead simple way to cache objects temporarily to help reduce the amount of network requests. A great use-case is when you need to cache image data during a session.

#### JSON.swift

JSON is a collection of enums, classes and functions for parsing JSON into pre-defined structs or classes that represent the data models you're choosing to work with. It's heavly inspired by this [NSScreencast episode](http://nsscreencast.com/episodes/130-swift-json-redux-part-1).

Example of a Book struct that implements the [JSONDecode protocol](https://github.com/nathanborror/NBKit/blob/master/NBKit/NBKit/JSON.swift#L91):

``` swift
struct Book: JSONDecode {
  let id:Int
  let title:String
  let plot:String?
  
  static func fromJSON(j:JSValue) -> Book? {
    switch j {
    case .JSObject(let d):
      return Book(
        id:     d["id"] >>> JSInt.fromJSON ?? 0,
        title:  d["title"] >>> JSString.fromJSON ?? "",
        plot:   d["plot"] >>> JSString.fromJSON
      )
    default:
      return nil
  }
}
```

Imagine you've made a request (using NSURLSession or Alamofire) for a list of books. You've probably got an NSData object so you'd do the following to convert it into an array of Book objects:

``` swift
let json = JSValue.decode(data)
let books = json >>> JSArray<Book, Book>.fromJSON
```

#### Layout.swift

Layout is a more convenient way to programmatically work with [Auto-Layout](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/Introduction/Introduction.html).

#### Regex.swift

Regex is a more convenient way to work with regular expressions.

--

#### Deprecated

* Parser.swift is deprecated—use [JSON.swift](https://github.com/nathanborror/NBKit/blob/master/NBKit/NBKit/JSON.swift).
* Request.swift is deprecated—use [Alamofire](https://github.com/Alamofire/Alamofire).
