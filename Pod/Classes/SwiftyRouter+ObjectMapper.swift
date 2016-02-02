//
//  SwiftyRouter+ObjectMapper.swift
//  Pods
//
//  Created by Lukasz Mroz on 02.02.2016.
//
//

import Alamofire
import ObjectMapper

public extension Request {
    
    private func parse<T: Mappable>(type: T.Type, objectGetter: String -> Any?, completion: SwiftyRouterResult -> Void) -> Self  {
        return response(completionHandler: { (request, response, data, error) -> Void in
            
            if let error = error {
                completion(SwiftyRouterResult.Failure(error))
            }
            
            if let data = data,
                json = NSString(data: data, encoding: NSUTF8StringEncoding) as? String,
                object = objectGetter(json) {
                    completion(SwiftyRouterResult.Success(object))
            }
            
            let parserError = NSError(domain: "com.droidsonroids.SwiftyRouterResult", code: 420, userInfo: ["error": "Parse error."])
            completion(SwiftyRouterResult.Failure(parserError))
        })
    }
    
    public func parseObject<T: Mappable>(type: T.Type, completion: SwiftyRouterResult -> Void) -> Self  {
        return parse(type, objectGetter: { Mapper<T>().map($0) }, completion: completion)
    }
    
    public func parseArray<T: Mappable>(type: T.Type, completion: SwiftyRouterResult -> Void) -> Self  {
        return parse(type, objectGetter: { Mapper<T>().mapArray($0) }, completion: completion)
    }
    
}