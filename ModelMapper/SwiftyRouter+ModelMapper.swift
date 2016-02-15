//
//  SwiftyRouter+ModelMapper.swift
//  SwiftyRouter
//
//  Created by Lukasz Mroz on 02.02.2016.
//  Copyright (c) 2016 Droids on Roids LLC.
//

import Alamofire
import Mapper

extension Request {
    
    private func parse<T: Mappable>(type: T.Type, objectGetter: NSDictionary -> Any?, completion: SwiftyRouterResult -> Void) -> Self {
        return response(completionHandler: { (request, response, data, error) -> Void in
            
            if let error = error {
                completion(SwiftyRouterResult.Failure(error))
                return
            }
            
            guard let data = data else {
                completion(SwiftyRouterResult.Failure(ParseError.EmptyData.error))
                return
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                if let json = json as? NSDictionary,
                    object = objectGetter(json) {
                        completion(SwiftyRouterResult.Success(object))
                        return
                } else if let json = json as? NSArray {
                    var returnArray = [T]()
                    for dict in json {
                        if let dict = dict as? NSDictionary, object = objectGetter(dict) as? T {
                            returnArray.append(object)
                        }
                    }
                    completion(SwiftyRouterResult.Success(returnArray))
                    return
                }
            } catch {}
            
            completion(SwiftyRouterResult.Failure(ParseError.CannotParse.error))
        })
    }
    
    public func parseObject<T: Mappable>(type: T.Type, completion: SwiftyRouterResult -> Void) -> Self {
        return parse(type, objectGetter: { T.from($0) }, completion: completion)
    }
    
    public func parseArray<T: Mappable>(type: T.Type, completion: SwiftyRouterResult -> Void) -> Self {
        return parse(type, objectGetter: { T.from($0) }, completion: completion)
    }
    
}