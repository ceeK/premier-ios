//
//  ResourceOperationSpec.swift
//  PremierSwift
//
//  Created by Chris Howell on 17/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import Quick
import Nimble

@testable
import PremierSwift

final class ResourceOperationSpec: QuickSpec {
    
    override func spec() {
        describe("a resource operation") {
        
            var loader: StubLoader!
            var fakeResource: Resource<String>!
            var resourceOperation: ResourceOperation<String>!
            
            beforeEach {
                loader = StubLoader()
                
                fakeResource = Resource<String>(url: URL(string: "foo")!, parse: { _ in
                    return "bar"
                })
                
                resourceOperation = ResourceOperation(resource: fakeResource, loader: loader, completion: { _ in })
            }
            
            context("when started") {
                it("asks the loader to load the resource") {
                    resourceOperation.start()
                    expect(loader.lastURLLoad).to(equal(fakeResource.url))
                }
            }
            
        }
    }
    
}

fileprivate final class StubLoader: ResourceLoader {
    
    var lastURLLoad: URL?

    func load<String>(resource: Resource<String>, completion: @escaping (NetworkResponse<String>) -> Void) {
        self.lastURLLoad = resource.url
    }
    
}
