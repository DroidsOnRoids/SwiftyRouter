import XCTest
import SwiftyRouter

class Tests: XCTestCase {
    
    enum HTTPBin: Endpointable {
        
        case headers
        
        var baseUrl: String { return "https://httpbin.org" }
        var endpoint: Subendpointable {
            switch self {
            case .headers:
                return HeadersEndpoint()
            }
        }
        
    }
    
    struct HeadersEndpoint: Subendpointable {
        
        var path: String { return "/headers" }
        var method: EndpointMethod { return .GET }
        var parameters: [String: AnyObject]? { return nil }
        var headers: [String : String]? { return nil }
        
    }
    
    func testRequest() {
        let expectation = expectationWithDescription("Request")
        
        HTTPBin.headers.request { (result) -> Void in
            expectation.fulfill()
            
            switch result {
            case .Success(let data):
                guard let data = data as? NSData else {
                    XCTFail("Received data is not NSData")
                    return
                }
                
                XCTAssert(data.length > 0, "Received data should not be empty.")
            case .Failure(let error):
                XCTFail("Request error: \(error)")
            }
        }
        
        waitForExpectationsWithTimeout(3.0, handler: nil)
    }
    
    func testParseJSON() {
        let expectation = expectationWithDescription("Parse JSON")
        
        HTTPBin.headers.request().parseJSON { (result) -> Void in
            expectation.fulfill()
            
            switch result {
            case .Success(let json):
                guard let _ = json as? [String : AnyObject] else {
                    XCTFail("Received JSON should be Dictionary<String, AnyObject>")
                    return
                }
            case .Failure(let error):
                XCTFail("Parse JSON error: \(error)")
            }
        }
        
        waitForExpectationsWithTimeout(3.0, handler: nil)
    }
    
 }
