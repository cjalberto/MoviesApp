//
//  MovieCollectionViewCell.swift
//  moviewsApp
//
//  Created by Carlos Jaramillo on 9/21/18.
//  Copyright © 2018 carlos jaramillo. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: BaseMovieCollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setupViews(){
        self.addSubview(self.posterImiageView)
        self.posterImiageView.translatesAutoresizingMaskIntoConstraints = false
        self.posterImiageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.posterImiageView.bottomAnchor.constraint(equalTo: self.bottomAnchor , constant : -30).isActive = true
        self.posterImiageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.posterImiageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor , constant : -5).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant : 10).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant : -10).isActive = true
        self.titleLabel.font = UIFont.systemFont(ofSize: 17)
        self.titleLabel.textColor = .white
        self.titleLabel.textAlignment = .center
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.minimumScaleFactor = 0.8
        
        self.backgroundColor = UIColor(named: "cellColor")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.posterImiageView.image = nil
        self.titleLabel.text = ""
    }
    
    func loadDataCell(movie : Movie){
        self.titleLabel.text = movie.title
        if let posterPath = movie.posterPath{
            guard let url = Api.createUrl(infoRequest: ["posterPath" : posterPath], typeService: baseURLS.posters) else {
                return
            }
            self.posterImiageView.loadPicture(of: url)
        }
    }

}
