//
//  CellImageLoaderSpec.swift
//  PremierSwift
//
//  Created by Chris Howell on 17/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import Quick
import Nimble

@testable
import PremierSwift

final class CellImageLoaderSpec: QuickSpec {
    
    override func spec() {
        describe("a cell image loader") {
            
            var operationQueue: OperationQueue!
            var cellImageLoader: CellImageLoader!
            
            beforeEach {
                operationQueue = OperationQueue()
                operationQueue.isSuspended = true
                
                cellImageLoader = CellImageLoader(queue: operationQueue)
            }
            
            context("that is loading an image for a cell") {
            
                beforeEach {
                    let fakeURL = URL(string: "foobar")!
                    let fakeCell = UITableViewCell()
                    cellImageLoader.loadImage(imageURL: fakeURL, cell: fakeCell, completion: { _ in })
                }
                
                it("will add an operation to the queue") {
                    expect(operationQueue.operationCount).to(equal(1))
                }
                
            }
            
            context("when a cell already has a load request") {
                
                beforeEach {
                    let fakeURL = URL(string: "foobar")!
                    let fakeCell = UITableViewCell()
                    cellImageLoader.loadImage(imageURL: fakeURL, cell: fakeCell, completion: { _ in })
                    cellImageLoader.loadImage(imageURL: fakeURL, cell: fakeCell, completion: { _ in })
                }
                
                it("will cancel the previous request") {
                    let cancelledOperations = operationQueue.operations.filter {
                        $0.isCancelled
                    }.count
                    expect(cancelledOperations).to(equal(1))
                }
                
            }
            
        }
    }
    
}
