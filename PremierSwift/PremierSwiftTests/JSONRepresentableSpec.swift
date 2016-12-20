//
//  JSONRepresentableSpec.swift
//  PremierSwift
//
//  Created by Chris Howell on 17/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import Quick
import Nimble

@testable
import PremierSwift

final class JSONRepresentableSpec: QuickSpec {
    
    override func spec() {
        describe("a JSON representable conformer") {
        
            context("when parsing an invalid JSON key") {
                
                it("returns nil") {
                    let emptyJSON: JSONDictionary = [:]
                    let parsedValue: String? = JSONRepresentableStruct.parse(json: emptyJSON, key: "invalid")
                    expect(parsedValue).to(beNil())
                }
                
            }
            
            context("when parsing a valid JSON key") {
                
                it("returns the parsed value") {
                    let value = "bar"
                    let nonEmptyJSON: JSONDictionary = ["foo" : value]
                    let parsedValue: String? = JSONRepresentableStruct.parse(json: nonEmptyJSON, key: "foo")
                    expect(parsedValue).to(equal(value))
                }
                
            }
            
        }
    }
    
}

struct JSONRepresentableStruct: JSONRepresentable {
    init?(json: JSONDictionary) {}
}
