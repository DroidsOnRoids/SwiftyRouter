//
//  SwiftyRouter+SwiftyJSON.swift
//  Pods
//
//  Created by Lukasz Mroz on 02.02.2016.
//
//

import Alamofire
import SwiftyJSON

extension Request {
    
    public func parseSwiftyJSON(completion: (Any?, NSError?) -> ()) -> Self {
        return self.response(queue: nil, responseSerializer: Request.JSONResponseSerializer(options: .AllowFragments), completionHandler: { response in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                if response.result.isFailure {
                    completion(nil, response.result.error)
                } else {
                    let responseJSON = SwiftyJSON.JSON(response.result.value!)
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(responseJSON.object, responseJSON.error)
                    })
                }
            })
        })
    }
    
}