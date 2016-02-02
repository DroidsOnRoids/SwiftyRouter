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

public enum SwiftyRouterResult {

    case Success(Any)
    case Failure(NSError)
    
}

public protocol Endpointable {
    
    var baseUrl: String { get }
    var endpoint: Subendpointable { get }
    
}

public protocol Subendpointable {
    
    var path: String { get }
    var method: EndpointMethod { get }
    var parameters: [String: AnyObject]? { get }
    var headers: [String : String]? { get }
    
}

extension Endpointable {
    
    public func request() -> Request {
        return request(nil)
    }
    
    public func request(completion: (SwiftyRouterResult -> Void)?) -> Request {
        let request = Alamofire.request(Alamofire.Method(rawValue: endpoint.method.rawValue)!,
            baseUrl + endpoint.path,
            parameters: endpoint.parameters,
            encoding: .JSON,
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
