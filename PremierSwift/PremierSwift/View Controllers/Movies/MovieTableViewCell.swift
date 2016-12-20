//
//  MovieTableViewCell.swift
//  PremierSwift
//
//  Created by Chris Howell on 15/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    
    var posterImage: UIImage? {
        didSet {
            posterImageView.image = posterImage
        }
    }
    
    private let posterImageView = UIImageView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let synopsisLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        
        synopsisLabel.numberOfLines = 0
        synopsisLabel.textColor = .gray
        synopsisLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        posterImageView.contentMode = .scaleAspectFill
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(synopsisLabel)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
    
    private func setupLayout() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        synopsisLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = contentView.layoutMarginsGuide
        let imageWidth: CGFloat = 92
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: margins.topAnchor),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),
            posterImageView.widthAnchor.constraint(equalToConstant: imageWidth),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: margins.trailingAnchor),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: posterImageView.bottomAnchor),
            
            synopsisLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            synopsisLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            synopsisLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            synopsisLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
    }
    
    func configure(title: String?, synopsis: String?) {
        self.titleLabel.text = title
        self.synopsisLabel.text = synopsis
    }
    
}
