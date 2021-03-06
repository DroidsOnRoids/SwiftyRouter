//
//  SwiftyRouter.swift
//  SwiftyRouter
//
//  Created by Piotr Sochalewski on 02.02.2016.
//  Copyright (c) 2016 Droids on Roids LLC.
//

import Alamofire

/**
 HTTP method definitions.
 
 See https://tools.ietf.org/html/rfc7231#section-4.3
 */
public typealias EndpointMethod = Alamofire.Method

/**
 Result that has two cases.
 - `Success(Any)`: Successful. Returns `Any` in its associated type.
 - `Failure(NSError)`: Failure. Returns `NSError` in its associated type.
 */
public enum SwiftyRouterResult {

    case Success(Any)
    case Failure(NSError)
    
}

/**
 Protocol that should be implemented by API service's `enum`. It should have `case`s being endpoints.
 Required variables are:
 - `baseUrl`: The path that would be a prefix to the API request URL address (should not end with `/`)
 - `endpoint`: The endpoint that should be executed, preferably returned inside `switch` when there is more than one endpoint
 */
public protocol Endpointable {

    var baseUrl: String { get }
    var endpoint: Subendpointable { get }
    
}

/**
 Protocol that should be implemented by endpoint's `struct` or `class`.
 Required variables are:
 - `path`: The path that should be added after `baseUrl` to be completed URL address (should start with `/`)
 - `method`: The HTTP method
 - `parameters`: The parameters send as JSON or in URL (GET method exclusively) (can be `nil`)
 - `headers`: The HTTP headers (can be `nil`)
 */
public protocol Subendpointable {
    
    var path: String { get }
    var method: EndpointMethod { get }
    var parameters: [String: AnyObject]? { get }
    var headers: [String : String]? { get }
    
}

extension Endpointable {
    
    /**
     Creates a request using Alamofire.
     - returns: The created request
     */
    public func request() -> Request {
        return request(nil)
    }
    
    /**
     Creates a request using Alamofire.
     - parameter completion: A closure that lets you grab result
     - returns: The created request
     */
    public func request(completion: (SwiftyRouterResult -> Void)?) -> Request {
        let request = Alamofire.request(endpoint.method,
            baseUrl + endpoint.path,
            parameters: endpoint.parameters,
            encoding: endpoint.method == .GET ? .URL : .JSON,
            headers: endpoint.headers)
        
        request.responseData { response in
            if let completion = completion {
                if response.result.error != nil {
                    completion(SwiftyRouterResult.Failure(response.result.error!))
                } else {
                    completion(SwiftyRouterResult.Success(response.result.value!))
                }
            }
        }
        
        return request
    }
    
}

extension Request {
    
    public enum ParseError {
        case EmptyData
        case CannotParse
        
        var domain: String {
            return "com.droidsonroids.SwiftyRouterResult"
        }
        
        var error: NSError {
            switch self {
            case .CannotParse:
                return NSError(domain: domain, code: 420, userInfo: ["error": "Parse error."])
            case .EmptyData:
                return NSError(domain: domain, code: 421, userInfo: ["error": "Empty data."])
            }
        }
    }
    
    /**
     Returns a JSON object constructed from the response data using `NSJSONSerialization`.
     - parameter completion: A closure that lets you grab result
     */
    public func parseJSON(completion: (SwiftyRouterResult -> Void)) -> Void {
        self.responseJSON { response in
            if response.result.error != nil {
                completion(SwiftyRouterResult.Failure(response.result.error!))
            } else {
                completion(SwiftyRouterResult.Success(response.result.value!))
            }
        }
    }
    
}