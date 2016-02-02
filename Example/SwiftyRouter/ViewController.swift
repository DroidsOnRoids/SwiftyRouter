//
//  ViewController.swift
//  SwiftyRouter
//
//  Created by Piotr Sochalewski on 02/01/2016.
//  Copyright (c) 2016 Piotr Sochalewski. All rights reserved.
//

import UIKit
import SwiftyRouter

enum Github: Endpointable {
    
    case Repos(String)
    case UserInfo(String)
    
    var baseUrl: String {
        return "https://api.github.com"
    }
    
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
    var parameters: [String: AnyObject]? { return nil }
    var headers: [String : String]? { return nil }
    
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
    var parameters: [String: AnyObject]? { return nil }
    var headers: [String : String]? { return nil }
    
    init(username: String) {
        self.username = username
    }
    
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Github.Repos("mjacko").request().parseJSON { (response) -> Void in
            print(response)
        }
        
        Github.Repos("mjacko").request().parseSwiftyJSON { (json, error) -> () in
            print(json)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}