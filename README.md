# SwiftyRouter

[![Version](https://img.shields.io/cocoapods/v/SwiftyRouter.svg?style=flat)](http://cocoapods.org/pods/SwiftyRouter)
[![License](https://img.shields.io/cocoapods/l/SwiftyRouter.svg?style=flat)](http://cocoapods.org/pods/SwiftyRouter)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyRouter.svg?style=flat)](http://cocoapods.org/pods/SwiftyRouter)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Swift 2.x, iOS 8+

## Installation

SwiftyRouter is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftyRouter"
```

If you want to parse response to objects, and you are using [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper), [ModelMapper](https://github.com/lyft/mapper) or [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) we got you covered. Simply use one of the lines below:

```ruby
pod "SwiftyRouter/ObjectMapper"
pod "SwiftyRouter/ModelMapper"
pod "SwiftyRouter/SwiftyJSON"
```

## Usage

SwiftyRouter lets you get easily raw `NSData`, parsed `JSON` or mapped model received from API request this way:

```swift
MyAPI.Authenticate().request().parseJSON(_:)
MyAPI.UserInfo(username: "trickyusername").request().parseObject(_:) // via ModelMapper or ObjectMapper
```

### Example

To make it works well, first, import the module.

```swift
import SwiftyRouter
```

Then create `enum` for selected API service, i.e. GitHub API. Remember to implement `Endpointable` protocol with all required properties (meaning `baseUrl` and `endpoint`). In this case we cover two endpoints: user repos, and user info.

```swift
enum Github: Endpointable {

    case Repos(String)
    case UserInfo(String)

    var baseUrl: String { return "https://api.github.com" }

    var endpoint: Subendpointable {
        switch self {
        case .Repos(let username):
            return ReposEndpoint(username: username)
        case .UserInfo(let username):
            return UserInfoEndpoint(username: username)
        }
    }

}
```

Then implement previously defined endpoints like structs or classes with `Subendpointable` protocol. One more time fill all required properties (`path`, `method`, `parameters` and `headers`). We've got here quite convenient `init` with username being part of URL.

```swift
struct ReposEndpoint: Subendpointable {

    // We specify the parameters
    let username: String!

    // Required methods/parameters
    var path: String { return "/users/\(username)/repos" }
    var method: EndpointMethod { return .GET }
    var parameters: [String: AnyObject]? { return nil }
    var headers: [String : String]? { return nil }

    init(username: String) {
        self.username = username
    }

}

struct UserInfoEndpoint: Subendpointable {

    // We specify the parameters
    let username: String!

    // Required methods/parameters
    var path: String { return "/users/\(username)" }
    var method: EndpointMethod { return .GET }
    var parameters: [String: AnyObject]? { return nil }
    var headers: [String : String]? { return nil }

    init(username: String) {
        self.username = username
    }

}
```

After that everything is done. You can easily receive needed data this way.

```swift
Github.UserInfo("DroidsOnRoids").request { result in
    switch result {
    case .Success(let data):
        print("Just NSData: \(data)")
    case .Failure(let error):
        print(error)
    }
}
```

Need more than just clear `NSData`? Try `parseJSON()`.

```swift
Github.Repos("DroidsOnRoids").request().parseJSON { result in
    switch result {
    case .Success(let json):
        print("What a beautiful dict!\n\(json)")
    case .Failure(let error):
        print(error)
    }
}
```

You can also map the response to objects using `ObjectMapper` or `ModelMapper` (needs additional pod specified in <a href="#installation">Installation</a>).
```swift
Github.Repos("DroidsOnRoids").request().parseArray(Repository.self) { result in
    switch result {
    case .Success(let object):
        print(object)
    case .Failure(let error):
        print(error)
    }
}
```

## Author

Droids on Roids LLC<br />
Piotr Sochalewski, piotr.sochalewski@droidsonroids.pl<br />
Łukasz Mróz, lukasz.mroz@droidsonroids.pl

## License

SwiftyRouter is available under the MIT license. See the LICENSE file for more info.
