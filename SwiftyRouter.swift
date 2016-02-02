//
//  SwiftyRouter.swift
//  Pods
//
//  Created by Piotr Sochalewski on 02.02.2016.
//
//

import Alamofire

public enum EndpointMethod {
    
    case GET
    case POST
    case PUT
    case DELETE
    
}

public protocol Endpointable {
    
    var baseUrl: String { get }
    var endpoint: Subendpointable { get }
    
}

public protocol Subendpointable {
    
    var path: String { get }
    var method: EndpointMethod { get }
    
}

extension Endpointable {
    
    public func request(completionBlock: () -> ()) {
        print(endpoint.path)
    }
    
}

extension Request {
    
    public func parseObject(completionBlock: () -> ()) {
    }
    
}