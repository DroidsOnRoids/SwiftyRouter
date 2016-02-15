//
//  SwiftyRouter+ObjectMapper.swift
//  SwiftyRouter
//
//  Created by Lukasz Mroz on 02.02.2016.
//  Copyright (c) 2016 Droids on Roids LLC.
//

import Alamofire
import ObjectMapper

public extension Request {
    
    private func parse<T: Mappable>(type: T.Type, objectGetter: String -> Any?, completion: SwiftyRouterResult -> Void) -> Self {
        return response(completionHandler: { (request, response, data, error) -> Void in
            
            if let error = error {
                completion(SwiftyRouterResult.Failure(error))
                return
            }
            
            guard let data = data else {
                completion(SwiftyRouterResult.Failure(ParseError.EmptyData.error))
                return
            }
            
            if let json = String(data: data, encoding: NSUTF8StringEncoding),
                object = objectGetter(json) {
                    completion(SwiftyRouterResult.Success(object))
                    return
            }
            
            completion(SwiftyRouterResult.Failure(ParseError.CannotParse.error))
        })
    }
    
    public func parseObject<T: Mappable>(type: T.Type, completion: SwiftyRouterResult -> Void) -> Self {
        return parse(type, objectGetter: { Mapper<T>().map($0) }, completion: completion)
    }
    
    public func parseArray<T: Mappable>(type: T.Type, completion: SwiftyRouterResult -> Void) -> Self {
        return parse(type, objectGetter: { Mapper<T>().mapArray($0) }, completion: completion)
    }
    
}