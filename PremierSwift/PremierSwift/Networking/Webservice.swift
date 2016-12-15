//
//  Webservice.swift
//  PremierSwift
//
//  Created by Chris Howell on 15/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import Foundation

struct Resource<A> {
    /// The URL where the resource exists
    let url: URL
    /// A function that transforms raw data into `A`
    let parse: (Data) -> A?
}

extension Resource {

    /// A Resource initialiser that specifically handles JSON parsing.
    ///
    /// - Parameters:
    ///   - url: The URL where the resource exists.
    ///   - parseJSON: The parsing function that takes JSON object.
    init(url: URL, parseJSON: @escaping (AnyObject) -> A?) {
        self.url = url
        self.parse = { data in
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject else { return nil }
            return parseJSON(json)
        }
    }
    
}

enum NetworkError: Error {
    /// Indicates a failed transformation of JSON into a model
    case parseFailure
}

enum NetworkResponse<T> {
    /// Indicates a successful network response, containing the parsed data
    case success(objects: T)
    /// Indicates an failed network response, containing the specific erro
    case error(type: NetworkError)
}

final class Webservice {

    /// The API key for TheMovieDB
    static private let apiKey = "e4f9e61f6ffd66639d33d3dde7e3159b"
    
    func load<T>(resource: Resource<T>, completion: @escaping (NetworkResponse<T>) -> Void) {
        let urlRequest = createURLRequest(url: resource.url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in

        }.resume()
        
    }
    
    private func createURLRequest(url: URL) -> URLRequest {
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: Webservice.apiKey)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems?.append(apiKeyQueryItem)
        
        guard let apiKeyURL = components?.url else {
            fatalError("Exception: Failed to add API key `\(Webservice.apiKey)` to resource URL `\(url)`")
        }
        
        return URLRequest(url: apiKeyURL)
    }
    
}