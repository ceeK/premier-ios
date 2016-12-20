//
//  JSONRepresentable.swift
//  PremierSwift
//
//  Created by Chris Howell on 15/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

protocol JSONRepresentable {
    
    init?(json: JSONDictionary)
    
    /// Parses a JSON dictionary for a particular key.
    ///
    /// - Parameters:
    ///   - json: The JSON dictionary to parse
    ///   - key: The key to fetch from the JSON dictionary
    /// - Returns: The parsed value
    static func parse<T>(json: JSONDictionary, key: String) -> T?
    
}

extension JSONRepresentable {
    
    /// Parses a JSON dictionary for a particular key. Prints an error if the key cannot be parsed.
    ///
    /// - Parameters:
    ///   - json: The JSON dictionary to parse
    ///   - key: The key to fetch from the JSON dictionary
    /// - Returns: The parsed value
    static func parse<T>(json: JSONDictionary, key: String) -> T? {
        guard let parsedValue = json[key] as? T else {
            print("Error: Cannot parse `\(key)` for `\(self)`")
            return nil
        }
        return parsedValue
    }
    
}
