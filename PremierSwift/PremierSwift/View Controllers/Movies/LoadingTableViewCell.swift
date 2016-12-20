//
//  LoadingTableViewCell.swift
//  PremierSwift
//
//  Created by Chris Howell on 16/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import UIKit

final class LoadingTableViewCell: UITableViewCell {

    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        activityIndicator.startAnimating()
        contentView.addSubview(activityIndicator)
        
        let margins = contentView.layoutMarginsGuide
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: margins.topAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.startAnimating()
    }
    
}
