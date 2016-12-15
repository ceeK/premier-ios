//
//  Webservice.swift
//  PremierSwift
//
//  Created by Chris Howell on 15/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

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
    /// Indicates no data was returned from the server
    case networkFailure
    /// Indicates a failed transformation of JSON into a model
    case parseFailure
}

enum NetworkResponse<T> {
    /// Indicates a successful network response, containing the parsed data
    case success(models: T)
    /// Indicates a failed network response, containing the specific erro
    case error(type: NetworkError)
}

final class Webservice {

    /// The API key for TheMovieDB
    static private let apiKey = "e4f9e61f6ffd66639d33d3dde7e3159b"
    
    func load<T>(resource: Resource<T>, completion: @escaping (NetworkResponse<T>) -> Void) {
        let urlRequest = authenticatedURLRequest(url: resource.url)
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.error(type: .networkFailure))
                }
                return
            }
            
            guard let models = resource.parse(data) else {
                DispatchQueue.main.async {
                    completion(.error(type: .parseFailure))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(models: models))
            }
            
        }.resume()
    }
    
    private func authenticatedURLRequest(url: URL) -> URLRequest {
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: Webservice.apiKey)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [apiKeyQueryItem]
        
        guard let apiKeyURL = components?.url else {
            fatalError("Exception: Failed to add API key `\(Webservice.apiKey)` to resource URL `\(url)`")
        }
        
        return URLRequest(url: apiKeyURL)
    }
    
}
