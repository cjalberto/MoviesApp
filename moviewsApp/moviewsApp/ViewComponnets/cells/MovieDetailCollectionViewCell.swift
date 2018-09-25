//
//  movieTableviewCellTableViewCell.swift
//  moviewsApp
//
//  Created by Carlos Jaramillo on 9/24/18.
//  Copyright © 2018 carlos jaramillo. All rights reserved.
//

import UIKit

class MovieDetailCollectionViewCell: BaseMovieCollectionViewCell {

    var overViewText : UITextView = UITextView()
    var yearLabel : UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setupViews() {
        self.addSubview(self.yearLabel)
        self.addSubview(self.posterImiageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.overViewText)
        
        self.posterImiageView.translatesAutoresizingMaskIntoConstraints = false
        self.posterImiageView.topAnchor.constraint(equalTo: self.topAnchor , constant : 8).isActive = true
        self.posterImiageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.posterImiageView.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant : 8).isActive = true
        self.posterImiageView.widthAnchor.constraint(equalToConstant : 100).isActive = true
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor , constant : 8).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.posterImiageView.trailingAnchor , constant : 8).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.yearLabel.leadingAnchor , constant : -8).isActive = true
        self.titleLabel.font = UIFont.systemFont(ofSize: 17)
        self.titleLabel.textColor = .white
        self.titleLabel.textAlignment = .left
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.minimumScaleFactor = 0.8
        
        self.yearLabel.translatesAutoresizingMaskIntoConstraints = false
        self.yearLabel.topAnchor.constraint(equalTo: self.topAnchor , constant : 8).isActive = true
        self.yearLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant : -8).isActive = true
        self.yearLabel.font = UIFont.systemFont(ofSize: 17)
        self.yearLabel.textColor = .white
        self.yearLabel.textAlignment = .right
        
        self.overViewText.translatesAutoresizingMaskIntoConstraints = false
        self.overViewText.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor , constant : 8).isActive = true
        self.overViewText.leadingAnchor.constraint(equalTo: self.posterImiageView.trailingAnchor , constant : 8).isActive = true
        self.overViewText.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant : -8).isActive = true
        self.overViewText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        self.overViewText.font = UIFont.systemFont(ofSize: 14)
        self.overViewText.textColor = .white
        self.overViewText.textAlignment = .left
        self.overViewText.backgroundColor = .black
        self.overViewText.indicatorStyle = .white
        
        self.backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.posterImiageView.image = nil
        self.titleLabel.text = ""
        self.overViewText.text = ""
        self.yearLabel.text = ""
    }
    
    func loadDataCell(movie : Movie){
        self.titleLabel.text = movie.title
        self.overViewText.text = movie.overview
        self.yearLabel.text = movie.releaseDate!.split(separator: "-")[0].description
        
        if let posterPath = movie.posterPath{
            guard let url = Api.createUrl(infoRequest: ["posterPath" : posterPath], typeService: baseURLS.posters) else {
                return
            }
            self.posterImiageView.loadPicture(of: url)
        }
    }
}
