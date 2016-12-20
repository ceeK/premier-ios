//
//  ErrorTableViewCell.swift
//  PremierSwift
//
//  Created by Chris Howell on 16/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import UIKit


final class ErrorTableViewCell: UITableViewCell {
    
    private let errorLabel = UILabel(frame: .zero)
    private let retryButton = UIButton(type: .system)
    private var retryHandler: (() -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        retryButton.addTarget(self, action: #selector(retryButtonPressed), for: .touchUpInside)
        retryButton.setTitle("Retry", for: .normal)
        
        contentView.addSubview(errorLabel)
        contentView.addSubview(retryButton)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let margins = contentView.layoutMarginsGuide
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            retryButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
    
    func configure(errorDescription: String?, retryHandler: @escaping () -> Void) {
        errorLabel.text = errorDescription
        self.retryHandler = retryHandler
    }
    
    @objc private func retryButtonPressed() {
        retryHandler?()
    }
    
}

