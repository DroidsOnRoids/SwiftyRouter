//
//  SwiftyRouter.swift
//  Pods
//
//  Created by Piotr Sochalewski on 02.02.2016.
//
//

import Alamofire

enum EndpointMethod {
    case GET
    case POST
    case PUT
    case DELETE
}

protocol Endpointable {
    var baseUrl: String { get }
    var endpoint: Subendpointable { get }
}

protocol Subendpointable {
    var path: String { get }
    var method: EndpointMethod { get }
}

extension Endpointable {
    func request(completionBlock: () -> ()) {
        print(endpoint.path)
    }
}

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

struct ReposEndpoint: Subendpointable {
    // We specify the parameters
    let username: String!
    
    // Required methods/parameters
    var path: String { return "/repos/\(username)" }
    var method: EndpointMethod { return .GET }
    
    init(username: String) {
        self.username = username
    }
}

struct UserInfoEndpoint: Subendpointable {
    // We specify the parameters
    let username: String!
    
    // Required methods/parameters
    var path: String { return "/user/\(username)" }
    var method: EndpointMethod { return .GET }
    
    init(username: String) {
        self.username = username
    }
}