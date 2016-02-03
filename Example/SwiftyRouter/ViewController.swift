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
    
    var baseUrl: String { return "https://api.github.com" }
    
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
    var path: String { return "/users/\(username)/repos" }
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
    var path: String { return "/users/\(username)" }
    var method: EndpointMethod { return .GET }
    var parameters: [String: AnyObject]? { return nil }
    var headers: [String : String]? { return nil }
    
    init(username: String) {
        self.username = username
    }
    
}

enum OpenWeatherMap: Endpointable {
    
    case Weather(String)
    
    var baseUrl: String { return "http://api.openweathermap.org/data/2.5" }
    
    var endpoint: Subendpointable {
        switch self {
        case .Weather(let city):
            return WeatherEndpoint(city: city)
        }
    }
    
}

struct WeatherEndpoint: Subendpointable {
    
    // We specify the parameters
    let city: String!
    
    // Required methods/parameters
    var path: String { return "/weather" }
    var method: EndpointMethod { return .GET }
    var parameters: [String: AnyObject]? { return ["q" : city, "appid" : "44db6a862fba0b067b1930da0d769e98"] }
    var headers: [String : String]? { return nil }
    
    init(city: String) {
        self.city = city
    }
    
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Github.UserInfo("mjacko").request().parseJSON { result in
            switch result {
            case .Success(let json):
                print(json)
            case .Failure(let error):
                print("Error: \(error)")
            }
        }
        
        OpenWeatherMap.Weather("Wroclaw").request().parseJSON { result in
            switch result {
            case .Success(let json):
                print(json)
            case .Failure(let error):
                print("Error: \(error)")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}