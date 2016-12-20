//
//  NetworkActivityIndicatorManager.swift
//  PremierSwift
//
//  Created by Chris Howell on 15/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import Foundation
import UIKit.UIApplication

protocol NetworkActivityIndicatorControlling {
    var isNetworkActivityIndicatorVisible: Bool { get set }
}

extension UIApplication: NetworkActivityIndicatorControlling {}

/// Allows the network activity indicator to only stop hiding when all network activity has stopped.
final class NetworkActivityIndicatorManager {

    /// Singleton instance of the NetworkActivityIndicatorManager.
    static let shared = NetworkActivityIndicatorManager()
    
    private var requests: Int = 0
    private let queue = DispatchQueue(label: "network_activity_indicator_queue")
    private(set) var networkActivityIndicatorControlling: NetworkActivityIndicatorControlling
    
    init(networkActivityIndicatorControlling: NetworkActivityIndicatorControlling = UIApplication.shared) {
        self.networkActivityIndicatorControlling = networkActivityIndicatorControlling
    }
    
    /// Requests that the activity indicator is shown
    func requestVisibility() {
        queue.sync {
            requests += 1
            networkActivityIndicatorControlling.isNetworkActivityIndicatorVisible = true
        }
    }

    /// Request that the activity indicator is hidden
    /// - Note: The indicator will only hide when all parties that have requested visibility, release visibility
    func releaseVisibility() {
        queue.sync {
            requests -= 1
            networkActivityIndicatorControlling.isNetworkActivityIndicatorVisible = requests != 0
        }
    }
    
}
