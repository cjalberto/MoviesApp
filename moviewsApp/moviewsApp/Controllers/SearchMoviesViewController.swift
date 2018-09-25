//
//  SearchMoviesViewController.swift
//  moviewsApp
//
//  Created by Carlos Jaramillo on 9/24/18.
//  Copyright © 2018 carlos jaramillo. All rights reserved.
//

import UIKit

class SearchMoviesViewController: BaseViewController {

    var cellId : String = "movie-cell"
    var movies : [Movie] = [] {
        didSet{
            DispatchQueue.main.async {
                if self.movies.count > 0{
                    self.view.hideToastActivity()
                }
                self.enableGetData = self.dataSource.currentPage < self.dataSource.numPages
                self.collection.reloadData()
            }
        }
    }
    var dataSource : DataSearch = DataSearch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cellHeight = 189
        
        self.registerClasesTableView()
        self.setupDelegates()
    }
    
    override func loadData() {
        let info : [String : Any] = ["page" :  self.dataSource.currentPage , "query" : self.search.text!]
        Api.shared.getDataService(infoRequest: info, typeService: baseURLS.Search) { (success, jsonData, error) in
            if success{
                guard let array = jsonData?["results"].array , let totalResults = jsonData?["total_results"].int , let numPages = jsonData?["total_pages"].int else{
                    self.view.makeToast("internal Error!")
                    return
                }
                self.dataSource.numPages = numPages
                self.dataSource.totalResults = totalResults
                self.title = "\(totalResults) Results"
                self.dataSource.currentPage = self.dataSource.currentPage + 1
                var movies = self.movies
                for item in array{
                    let movie = Movie(jsonData: item)
                    movies.append(movie)
                }
                self.movies = movies
            }
            else{
                self.view.makeToast("Error connection")
            }
            self.view.hideAllToasts()
        }
    }
    
    override func registerClasesTableView() {
        self.collection.register(MovieDetailCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
        self.collection.register(FooterActivityCollection.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: self.footerId)
    }
}

extension SearchMoviesViewController{
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return !((searchBar.text?.count == 0 || searchBar.text?.last == " ") && text == " ")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dataSource.currentPage = 1
        self.view.makeToastActivity(self.view.center)
        self.view.endEditing(true)
        self.loadData()
    }
}

extension SearchMoviesViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! MovieDetailCollectionViewCell
        cell.loadDataCell(movie: self.movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.movies.count == 0  ? 0 : 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let footer = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.footerId, for: indexPath) as! FooterActivityCollection
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
