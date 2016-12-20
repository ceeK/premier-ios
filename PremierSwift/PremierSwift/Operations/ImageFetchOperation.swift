//
//  ImageFetchOperation.swift
//  PremierSwift
//
//  Created by Chris Howell on 15/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import Foundation
import UIKit.UIImage

/// Encapsulates the loading of an image.
final class ImageFetchOperation: ResourceOperation<UIImage> {
    
    init(imageURL: URL, loader: ResourceLoader = Webservice(), completion: @escaping (NetworkResponse<UIImage>) -> Void) {
        let imageResource = Resource<UIImage>(url: imageURL, parse: { data in
            return UIImage(data: data)
        })
        
        super.init(resource: imageResource, loader: loader, completion: completion)
    }
    
}
