//
//  CellImageLoader.swift
//  PremierSwift
//
//  Created by Chris Howell on 16/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import UIKit

/// Handles the loading of images that are to be rendered within UITableViewCells.
/// CellImageLoader will cancel image requests for cells where a different image request has subsequently been made.
final class CellImageLoader {
    
    private let imageOperationQueue: OperationQueue
    
    /// A weak to weak mapping of cells to ImageFetchOperations. This is so we can cancel requests when a new request comes in for the same cell.
    private let cellImageOperationTable = NSMapTable<UITableViewCell, ImageFetchOperation>(keyOptions: .weakMemory, valueOptions: .weakMemory)
    
    init(queue: OperationQueue = OperationQueue()) {
        imageOperationQueue = queue
        imageOperationQueue.qualityOfService = .background
    }
    
    /// Loads an image for a cell.
    ///
    /// - Parameters:
    ///   - cell: The cell that the image is to be rendered.
    ///   - imageURL: The URL of the image.
    ///   - completion: A completion handler containing an optional image
    func loadImage(imageURL: URL, cell: UITableViewCell, completion: @escaping (UIImage?) -> Void) {
        cellImageOperationTable.object(forKey: cell)?.cancel()
        
        let imageFetchOperation = ImageFetchOperation(imageURL: imageURL) { response in
            switch response {
            case .success(let image):
                completion(image)
            case .failure(let error):
                print("Error fetching image: \(error)")
                completion(nil)
            }
        }
        
        cellImageOperationTable.setObject(imageFetchOperation, forKey: cell)
        imageOperationQueue.addOperation(imageFetchOperation)
    }
    
}
