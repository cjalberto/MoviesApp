
import UIKit

protocol BaseViewControllerProtocol {
    func registerClasesTableView()
    func setupDelegates()
    func loadData()
}

class BaseViewController: UIViewController , BaseViewControllerProtocol{
    

    var search: UISearchBar = {
        let object = UISearchBar()
        object.barTintColor = UIColor(named: "primaryColor")
        return object
    }()
    var collection : UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        let object = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        object.backgroundColor = .black
        object.backgroundColor = .clear
        object.showsVerticalScrollIndicator = false
        object.alwaysBounceVertical = false
        return object
    }()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    
    var footerId : String = "footer-activity"
    var enableGetData : Bool = false
    var cellHeight : CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    func addRefresh(){
        self.collection.alwaysBounceVertical = true
        self.refreshControl.tintColor = .white
        self.refreshControl.addTarget(self, action: #selector(self.refreshCollection), for: .valueChanged)
        self.collection.addSubview(self.refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        ImageLoader.shared.clearCache()
    }
    
    func setupViews(){
        self.view.addSubview(self.search)
        self.search.translatesAutoresizingMaskIntoConstraints = false
        self.search.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.search.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.search.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.search.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        self.view.addSubview(self.collection)
        self.collection.translatesAutoresizingMaskIntoConstraints = false
        self.collection.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.collection.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.collection.topAnchor.constraint(equalTo: self.search.bottomAnchor).isActive = true
        self.collection.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.backgroundColor = .black
    }
    
    func setupDelegates(){
        self.search.delegate = self
        self.collection.delegate = self
        self.collection.dataSource = self
    }
    
    @objc func refreshCollection(){}
    
    func loadData(){}
    
    func registerClasesTableView() {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

extension BaseViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
extension BaseViewController : UISearchBarDelegate{
    
}

extension BaseViewController : UICollectionViewDelegateFlowLayout{
    
}

extension BaseViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if self.enableGetData{
            self.loadData()
        }
    }
}

extension BaseViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.cellHeight)
    }
}
