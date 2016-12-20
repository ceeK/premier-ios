//
//  Webservice.swift
//  PremierSwift
//
//  Created by Chris Howell on 15/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import Foundation
import UIKit.UIApplication

private struct WebserviceConstants {
    static let apiKey = "e4f9e61f6ffd66639d33d3dde7e3159b"
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
    case failure(error: NetworkError)
}

protocol NetworkDataTask {
    func resume()
}

extension URLSessionDataTask: NetworkDataTask {}

protocol NetworkAccessing {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> NetworkDataTask
}

extension URLSession: NetworkAccessing {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkDataTask {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

/// Controls the loading of arbitrary resources from the network
final class Webservice {

    /// The API key for TheMovieDB
    private let apiKey: String

    /// A client used to access the network
    let networkClient: NetworkAccessing
    
    init(networkClient: NetworkAccessing = URLSession.shared, apiKey: String = WebserviceConstants.apiKey) {
        self.networkClient = networkClient
        self.apiKey = apiKey
    }

    /// Loads a resource from the network and callsback with a response.
    ///
    /// - Parameters:
    ///   - resource: The resource to load.
    ///   - completion: A `NetworkResponse` of either success or failure
    func load<T>(resource: Resource<T>, completion: @escaping (NetworkResponse<T>) -> Void) {
        
        var urlRequest = authenticatedURLRequest(url: resource.url)
        urlRequest.timeoutInterval = 10
        
        NetworkActivityIndicatorManager.shared.requestVisibility()
        networkClient.dataTask(with: urlRequest) { (data, _, error) in
            
            NetworkActivityIndicatorManager.shared.releaseVisibility()
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(error: .networkFailure))
                }
                return
            }
            
            guard let models = resource.parse(data) else {
                DispatchQueue.main.async {
                    completion(.failure(error: .parseFailure))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(models: models))
            }
            
        }.resume()
    }
    
    private func authenticatedURLRequest(url: URL) -> URLRequest {
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: apiKey)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [apiKeyQueryItem]
        
        guard let apiKeyURL = components?.url else {
            fatalError("Exception: Failed to add API key `\(apiKey)` to resource URL `\(url)`")
        }
        
        return URLRequest(url: apiKeyURL)
    }
    
}
