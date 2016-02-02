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
    
    public func parseObject<T: Mappable>(type: T.Type, completion: SwiftyRouterResult -> Void) -> Self  {
        return response(completionHandler: { (request, response, data, error) -> Void in
            
            if let error = error {
                completion(SwiftyRouterResult.Failure(error))
            }
            
            if let data = data,
                json = NSString(data: data, encoding: NSUTF8StringEncoding),
                object = Mapper<T>().map(json) {
                    completion(SwiftyRouterResult.Success(object))
            }
            
            let parserError = NSError(domain: "com.droidsonroids.SwiftyRouterResult", code: 420, userInfo: ["error": "Parse error."])
            completion(SwiftyRouterResult.Failure(parserError))
        })
    }
    
}