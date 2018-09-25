
import UIKit
import Toast_Swift

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var thrillerButton: UIButton!
    @IBOutlet weak var posterMovieImage: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var nameMovieLabel: UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var topLayoutButton: NSLayoutConstraint!
    
    var movie : Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadDataView()
    }
    
    func setupDelegates() {
        scroll.delegate = self
    }
    
    /// carga la data de la pelicula en la interfaz
    func loadDataView(){
        guard   let path = self.movie?.posterPath ,
            let overview = self.movie?.overview ,
            let genres = self.movie?.genreIds ,
            let year = self.movie?.releaseDate ,
            let name = self.movie?.title else{
                
                return
        }
        
        self.thrillerButton.setImage(UIImage(named: "play-button")?.withRenderingMode(.alwaysTemplate) , for: .normal)
        self.thrillerButton.tintColor = UIColor(named: "primaryColor")
        
        self.posterMovieImage.loadPicture(of: "\(baseURLS.posters.rawValue)\(path)")
        
        self.overviewLabel.text = overview
        self.overviewLabel.numberOfLines = 0
        self.overviewLabel.lineBreakMode = .byWordWrapping
        self.overviewLabel.preferredMaxLayoutWidth = self.scroll.frame.width
        
        self.genresLabel.text = self.generateGenreText(genreIds: genres as! [Int])
        
        self.yearLabel.text = year.split(separator: "-")[0].description
        
        self.nameMovieLabel.text = name
        
        self.title = name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.scroll.layoutIfNeeded()
        self.scroll.contentSize.height = self.overviewLabel.frame.maxY + 10
    }
    
    
    /// genera el texto de los generos que se muestra en la interfaz
    ///
    /// - Parameter genreIds: ids de los generos de la pelicula
    /// - Returns: texto a mostrar
    func generateGenreText(genreIds : [Int]) -> String{
        var text = ""
        genreIds.forEach { (id) in
            let genres = Genre.genres.filter({$0.id == id})
            if genres.count > 0{
                text = text + genres[0].name! + (id == genreIds.last! ? "" : ",")
            }
        }
        return text
    }
    
    
    /// metodo que muestra el modal con el trailer de la pelicula
    ///
    /// - Parameter sender: boton para abrir el modal
    @IBAction func showThriller(_ sender: UIButton) {
        if Api.isConnectedToInternet(){
            if let key = self.movie?.keyThriller {
                self.showThriller(key : key)
            }
            else{
                guard let id = self.movie?.id.description else {
                    self.view.makeToast("Error loading video")
                    return
                }
                let info : [String : Any] = ["id" : id]
                Api.shared.getDataService(infoRequest: info, typeService: baseURLS.thrillers) { (success, data, error) in
                    if success{
                        guard let results = data!["results"].array else{
                            self.view.makeToast("Error loading video")
                            return
                        }
                        if results.count > 0{
                            if results[0]["key"].exists(){
                                self.movie?.keyThriller = results[0]["key"].string
                                self.showThriller(key: (self.movie?.keyThriller)!)
                            }
                        }
                    }
                    else{
                        self.view.makeToast("Error loading video")
                    }
                }
            }
        }
        else{
            self.view.makeToast("error Connection")
        }
    }
}

extension MovieDetailViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.topLayoutButton.constant = 512 + (scrollView.contentOffset.y * -1)
    }
}


