//
//  HomeViewController.swift
//  moviewsApp
//
//  Created by Carlos Jaramillo on 9/21/18.
//  Copyright © 2018 carlos jaramillo. All rights reserved.
//

import UIKit
import Toast_Swift
import SwiftyJSON

class HomeViewController: BaseViewController{
    
    var sections : [Category] = Category.allValues
    let cellId : String = "scroll-section"
    let headerId : String = "header-section"
    let headerHeight : CGFloat = 40
    var firstLoad : Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cellHeight = (self.view.frame.height - self.search.frame.height)/3 - self.headerHeight
        
        self.registerClasesTableView()
        self.setupDelegates()
        self.addRefresh()
    }
    
    
    override func registerClasesTableView() {
        self.collection.register(ScrollSectionTableViewCell.self, forCellWithReuseIdentifier: self.cellId)
        self.collection.register(SectionMoviesHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: self.headerId)
    }
    
    override func refreshCollection() {
        self.refreshControl.beginRefreshing()
        if Api.isConnectedToInternet(){
            self.collection.reloadData()
        }
        else{
            self.view.makeToast("Error connection")
        }
        self.refreshControl.endRefreshing()
    }
    
    @IBAction func goToSearch(_ sender: Any) {
        self.goToSearch()
    }
}

extension HomeViewController {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.firstLoad = false
        self.collection.reloadData()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! ScrollSectionTableViewCell
        cell.initCollection(category: self.sections[indexPath.section], text: self.search.text!, initCollection: self.firstLoad)
        cell.delegate = self
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerId, for: indexPath) as! SectionMoviesHeader
        header.title.text = self.sections[indexPath.section].rawValue.replacingOccurrences(of: "_", with: " ")
        
        return header
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension HomeViewController : ScrollSectionTableViewCellDelegate{
    
    func didSelectMovie( movie : Movie) {
        self.goToMovieDetail(movie: movie)
    }
}

