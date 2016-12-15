//
//  UITableView+Cells.swift
//  PremierSwift
//
//  Created by Chris Howell on 15/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// Registers a cell by using its `CustomStringConvertible` string as an identifier.
    ///
    /// - Parameter cellClass: The cell class to register
    func register(_ cellClass: AnyClass) {
        let cellName = String(describing: cellClass)
        register(cellClass, forCellReuseIdentifier: cellName)
    }
    
    /// Dequeues a custom UITableViewCell that uses its `CustomStringConvertible` string as an identifier.
    /// - Note: This method will cause a fatal error if the cell has not been previously registered.
    ///
    /// - Parameter indexPath: The indexPath to dequeue a cell for
    /// - Returns: The dequeued cell
    func dequeue<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        let cellIdentifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? T else {
            fatalError("Cell \(cellIdentifier) cannot be dequeued")
        }
        return cell
    }
    
}
