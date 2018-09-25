
import UIKit

protocol ScrollSectionTableViewCellDelegate : class {
    func didSelectMovie(movie : Movie)
}

class ScrollSectionTableViewCell: UICollectionViewCell {

    var collection: UICollectionView! = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        layout.scrollDirection = .horizontal
        let object = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        object.backgroundColor = .black
        object.showsHorizontalScrollIndicator = false
        return object
    }()
    weak var delegate : ScrollSectionTableViewCellDelegate?
    let cellId : String = "cell-movie"
    let footerId : String = "footer-activity"
    var dataSource : DataSearch = DataSearch()
    var category : Category = .popular
    
    var moviesFiltered : [Movie] = [] {
        didSet{
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
    }
    
    var movies : [Movie] = []{
        didSet{
            DispatchQueue.main.async {
                if self.moviesFiltered.count > 0{
                    self.hideToastActivity()
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
        self.registClass()
    }
    
    func setupViews(){
        
        self.addSubview(self.collection)
        self.collection.translatesAutoresizingMaskIntoConstraints = false
        self.collection.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.collection.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.collection.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.collection.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.collection.delegate = self
        self.collection.dataSource = self
    }
    
    func initCollection(category : Category , text : String , initCollection : Bool){
        if initCollection{
            self.category = category
            self.makeToastActivity(self.center)
            if self.movies.count == 0{
                self.loadData()
            }
        }
        else{
            if text.count == 0{
                self.moviesFiltered = self.movies
            }
            else{
                self.moviesFiltered = self.movies.filter({($0.title?.lowercased())!.range(of: text.lowercased()) != nil})
            }
        }
    }
    
    func loadData(){
        
        let info : [String : Any] = ["page" : self.dataSource.currentPage, "category" : self.category.rawValue ]
        Api.shared.getDataService(infoRequest: info, typeService: baseURLS.Movies) { (success, dataJson, error) in
            if success{
                var movies : [Movie] = self.moviesFiltered
                guard let array = dataJson?["results"].array , let totalResults = dataJson?["total_results"].int , let numPages = dataJson?["total_pages"].int else{
                    self.makeToast("internal Error")
                    return
                }
                self.dataSource.numPages = numPages
                self.dataSource.totalResults = totalResults
                self.dataSource.currentPage = self.dataSource.currentPage + 1
                for item in array{
                    let movie = Movie(jsonData : item)
                    movies.append(movie)
                }
                self.movies = movies
                self.moviesFiltered = movies
            }
            else{
                self.hideToastActivity()
                if self.collection.numberOfItems(inSection: 0) > 5{
                    self.collection.scrollToItem(at: IndexPath(row: 0, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
                }
                self.makeToast("Error Connection")
            }
        }
    }
    
    func registClass(){
        self.collection.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
        self.collection.register(FooterActivityCollection.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: self.footerId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ScrollSectionTableViewCell : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectMovie(movie: self.moviesFiltered[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if self.moviesFiltered.count > 0{
            self.loadData()
        }
    }
}

extension ScrollSectionTableViewCell : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moviesFiltered.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! MovieCollectionViewCell
        cell.loadDataCell(movie: self.moviesFiltered[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.footerId, for: indexPath)
        return footer
    }

}

extension ScrollSectionTableViewCell : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.height * 10/16 , height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if self.moviesFiltered.count > 5 && self.moviesFiltered.count == self.movies.count{
            return CGSize(width: 70, height:  self.frame.height)
        }
        return CGSize(width: 0, height: self.frame.height)
    }
}
