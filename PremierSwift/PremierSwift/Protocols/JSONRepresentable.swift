//
//  JSONRepresentable.swift
//  PremierSwift
//
//  Created by Chris Howell on 15/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import Foundation

protocol JSONRepresentable {
    init?(json: JSONDictionary)
    static func parse<T>(json: JSONDictionary, key: String) -> T?
}

extension JSONRepresentable {
    
    static func parse<T>(json: JSONDictionary, key: String) -> T? {
        guard let parsedValue = json[key] as? T else {
            print("Error: Cannot parse `\(key)` for `\(self)`")
            return nil
        }
        return parsedValue
    }
    
}
