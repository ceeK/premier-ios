//
//  ResourceOperation.swift
//  PremierSwift
//
//  Created by Chris Howell on 15/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import Foundation

protocol ResourceLoader {
    func load<T>(resource: Resource<T>, completion: @escaping (NetworkResponse<T>) -> Void)
}

extension Webservice: ResourceLoader {}

/// Encapsulates the loading of a resource.
class ResourceOperation<T>: Operation {
    
    private(set) var resource: Resource<T>
    private let completion: (NetworkResponse<T>) -> Void
    private let resourceLoader: ResourceLoader
    
    init(resource: Resource<T>, loader: ResourceLoader = Webservice(), completion: @escaping (NetworkResponse<T>) -> Void) {
        self.resource = resource
        self.resourceLoader = loader
        self.completion = completion
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        
        resourceLoader.load(resource: resource) { response in
            guard !self.isCancelled else { return }
            self.completion(response)
        }
        
    }
    
}
