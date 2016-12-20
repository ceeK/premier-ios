//
//  NetworkActivityManagerSpec.swift
//  PremierSwift
//
//  Created by Chris Howell on 17/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable
import PremierSwift

final class NetworkActivityIndicatorManagerSpec: QuickSpec {
    
    override func spec() {
        describe("a network activity indicator manager") {
            
            var networkActivityManager: NetworkActivityIndicatorManager!
            var mockNetworkActivityIndicatorControlling: NetworkActivityIndicatorControlling!
            
            beforeEach {
                mockNetworkActivityIndicatorControlling = MockNetworkActivityIndicatorControlling()
                networkActivityManager = NetworkActivityIndicatorManager(networkActivityIndicatorControlling: mockNetworkActivityIndicatorControlling)
            }
            
            context("when a single request for visibility has been made") {
                beforeEach {
                    networkActivityManager.requestVisibility()
                }
                
                it("should set the visibility to be true") {
                    expect(mockNetworkActivityIndicatorControlling.isNetworkActivityIndicatorVisible).to(beTrue())
                }
                
                context("and then released") {
                    beforeEach {
                        networkActivityManager.releaseVisibility()
                    }
                    
                    it("should set the visibility to false") {
                        expect(mockNetworkActivityIndicatorControlling.isNetworkActivityIndicatorVisible).to(beFalse())
                    }
                }
            }
            
            context("when more than one requests for visibility have been made") {
                beforeEach {
                    networkActivityManager.requestVisibility()
                    networkActivityManager.requestVisibility()
                }
                
                context("and only one released") {
                    beforeEach {
                        networkActivityManager.releaseVisibility()
                    }
                    
                    it("should keep visibility to true") {
                        expect(mockNetworkActivityIndicatorControlling.isNetworkActivityIndicatorVisible).to(beTrue())
                    }
                }
                
            }
        
        }
    }
    
}

private final class MockNetworkActivityIndicatorControlling: NetworkActivityIndicatorControlling {
    var isNetworkActivityIndicatorVisible: Bool = false
}
