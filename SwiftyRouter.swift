//
//  SwiftyRouter.swift
//  Pods
//
//  Created by Piotr Sochalewski on 02.02.2016.
//
//

import Alamofire

public enum EndpointMethod: String {
    
    case GET
    case POST
    case PUT
    case DELETE
    
}

/**
 Result that has two cases.
 - Success(Any): Successful. Returns `any` in its associated type.
 - Failure(NSError): Failure. Returns `NSError` in its associated type.
 */
public enum SwiftyRouterResult {

    case Success(Any)
    case Failure(NSError)
    
}

/**
 Protocol that should be implemented by API service `enum`. It should have `case`s being endpoints.
 Required variables are:
 - baseUrl: the path that would be prefix to API request URL address (should not end with `/`)
 - endpoint: the endpoint that should be executed, preferably returned inside `switch` when there is more than one endpoint
 */
public protocol Endpointable {

    var baseUrl: String { get }
    var endpoint: Subendpointable { get }
    
}

/**
 Protocol that should be implemented by endpoint's struct or class.
 Required variables are:
 - path: the path that should be added after `baseUrl` to be completed URL address (should start with `/`)
 - method: the HTTP method
 - parameters: the parameters send as JSON or in URL (GET method exclusively) (can be nil)
 - headers: the HTTP headers (can be nil)
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
     - returns: the created request
     */
    public func request() -> Request {
        return request(nil)
    }
    
    /**
     Creates a request using Alamofire.
     - parameter completion: a closure that lets you grab result
     - returns: the created request
     */
    public func request(completion: (SwiftyRouterResult -> Void)?) -> Request {
        let request = Alamofire.request(Alamofire.Method(rawValue: endpoint.method.rawValue)!,
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
     - parameter completion: a closure that lets you grab result
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
