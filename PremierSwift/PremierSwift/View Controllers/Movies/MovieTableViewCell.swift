//
//  MovieTableViewCell.swift
//  PremierSwift
//
//  Created by Chris Howell on 15/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    
    private let posterImageView = UIImageView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let synopsisLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(synopsisLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String?, synopsis: String?) {
        self.titleLabel.text = title
        self.synopsisLabel.text = synopsis
    }
    
}
