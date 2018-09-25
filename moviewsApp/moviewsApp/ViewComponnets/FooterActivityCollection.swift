//
//  footerActivity.swift
//  moviewsApp
//
//  Created by Carlos Jaramillo on 9/23/18.
//  Copyright © 2018 carlos jaramillo. All rights reserved.
//

import UIKit

class FooterActivityCollection: UICollectionReusableView {

    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.indicator.center = self.center
        self.indicator.startAnimating()
        self.addSubview(self.indicator)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.indicator.startAnimating()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}


