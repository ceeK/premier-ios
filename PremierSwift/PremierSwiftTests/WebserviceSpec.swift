//
//  WebserviceSpec.swift
//  PremierSwift
//
//  Created by Chris Howell on 17/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import Quick
import Nimble

@testable
import PremierSwift

final class WebserviceSpec: QuickSpec {
    
    override func spec() {
        describe("a webservice") {
            
            let fakeApiKey = "foo"
            let fakeResourceURL = URL(string: "http://www.example.com/resource")!
            
            var networkClient: MockURLSession!
            var webservice: Webservice!
            
            beforeEach {
                networkClient = MockURLSession()
                webservice = Webservice(networkClient: networkClient, apiKey: fakeApiKey)
            }
            
            context("when loading a resource") {
                beforeEach {
                    let fakeResource = Resource<Int>(url: fakeResourceURL, parseJSON: { JSON in
                        return 1234
                    })
                    webservice.load(resource: fakeResource, completion: { _ in })
                }
                
                it("makes a network request with the resource URL") {
                    expect(networkClient.lastRequest).toNot(beNil())
                }
                
                it("appends the API key onto the URL") {
                    let url = networkClient.lastRequest?.url?.absoluteString
                    expect(url).to(contain(fakeApiKey))
                }
                
            }
            
            context("when a successful response is received") {
                
                var resourceParseCalled = false
                var parsedValue: Int?
                
                beforeEach {
                    let fakeResource = Resource<Int>(url: fakeResourceURL, parse: { data in
                        resourceParseCalled = true
                        return 1234
                    })
                    
                    networkClient.handler.data = Data()
                    webservice.load(resource: fakeResource) { response in
                        guard case let .success(value) = response else { return }
                        parsedValue = value
                    }
                }
                
                it("attempts to parse the response") {
                    expect(resourceParseCalled).to(beTrue())
                }
                
                context("and parsing succeeds") {
                    it("returns a successful response") {
                        expect(parsedValue).toEventually(equal(1234))
                    }
                }
                
            }
            
            context("when a successful response is received but parsing fails") {
                
                var error: NetworkError?
                
                beforeEach {
                    let fakeResource = Resource<Int>(url: fakeResourceURL, parse: { data in
                        return nil
                    })
                    
                    networkClient.handler.data = Data()
                    webservice.load(resource: fakeResource) { response in
                        guard case let .failure(networkError) = response else { return }
                        error = networkError
                    }
                }
                
                it("returns a parse failure error") {
                    expect(error).toEventually(equal(NetworkError.parseFailure))
                }
                
            }
            
            context("when an unsuccessful response is received") {
                
                var error: NetworkError?
                
                beforeEach {
                    let fakeResource = Resource<Int>(url: fakeResourceURL, parse: { _ in return nil })
                    
                    webservice.load(resource: fakeResource) { response in
                        guard case let .failure(networkError) = response else { return }
                        error = networkError
                    }
                }
                
                it("returns a network failure error") {
                    expect(error).toEventually(equal(NetworkError.networkFailure))
                }
            }
            
        }
    }
    
}

private final class StubDataTask: NetworkDataTask {
    fileprivate func resume() {}
}

private final class MockURLSession: NetworkAccessing {
    
    fileprivate(set) var lastRequest: URLRequest?
    fileprivate var handler: (data: Data?, response: URLResponse?, error: Error?) = (nil, nil, nil)
    
    fileprivate func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkDataTask {
        lastRequest = request
        
        completionHandler(handler.data, handler.response, handler.error)
        
        return StubDataTask()
    }
    
}
