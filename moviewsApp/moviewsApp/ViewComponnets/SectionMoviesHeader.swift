//
//  sectionMoviesHeader.swift
//  moviewsApp
//
//  Created by Carlos Jaramillo on 9/22/18.
//  Copyright © 2018 carlos jaramillo. All rights reserved.
//

import UIKit

class SectionMoviesHeader: UICollectionReusableView {

    var title : UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.title)
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.title.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant : 15).isActive = true
        self.title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.title.font = UIFont.boldSystemFont(ofSize: 25)
        self.title.textColor = .white
        self.title.layer.shadowColor = UIColor.yellow.cgColor
        self.backgroundColor = .black
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
