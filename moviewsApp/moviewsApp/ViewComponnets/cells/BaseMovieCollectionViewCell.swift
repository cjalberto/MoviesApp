//
//  BaseCollectionViewCell.swift
//  moviewsApp
//
//  Created by Carlos Jaramillo on 9/25/18.
//  Copyright © 2018 carlos jaramillo. All rights reserved.
//

import UIKit

protocol BaseCollectionViewCellProtocol {
    func setupViews()
}
class BaseMovieCollectionViewCell: UICollectionViewCell , BaseCollectionViewCellProtocol{
    
    var posterImiageView: UIImageView = UIImageView()
    var titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        self.posterImiageView.backgroundColor = .gray
    }
    
    func setupViews() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
