
import Foundation
import SwiftyJSON

class Movie: NSObject {
    
    public var backdropPath: String?
    public var genreIds: NSArray?
    public var id: Int
    public var isAdults: Bool
    public var keyThriller: String?
    public var originalLanguage: String?
    public var overview: String?
    public var popularity: Double
    public var posterPath: String?
    public var releaseDate: String?
    public var title: String?
    public var video: Bool
    public var voteAverage: Double
    public var voteCount: Int
    
    
    init(jsonData : JSON) {
        self.voteCount = jsonData["vote_count"].exists() ? Int(jsonData["vote_count"].int!) : 0
        self.id = jsonData["id"].exists() ? Int(jsonData["id"].int!) : 0
        self.video = jsonData["video"].exists() ? jsonData["video"].bool! : false
        self.voteAverage = jsonData["vote_average"].exists() ? jsonData["vote_average"].double! : 0
        self.title = jsonData["title"].exists() ? jsonData["title"].string : ""
        self.popularity = jsonData["popularity"].exists() ? jsonData["popularity"].double! : 0
        self.posterPath = jsonData["poster_path"].exists() ? jsonData["poster_path"].string : ""
        self.originalLanguage = jsonData["original_language"].exists() ? jsonData["vote_count"].string : ""
        if let array = jsonData["genre_ids"].array{
            var genres : [Int] = []
            for json in array{
                guard let id = json.int else{
                    continue
                }
                genres.append(id)
            }
            self.genreIds = genres as NSArray
        }
        self.backdropPath = jsonData["backdrop_path"].exists() ? jsonData["backdrop_path"].string : ""
        self.isAdults = jsonData["adult"].exists() ? jsonData["adult"].bool! : false
        self.overview = jsonData["overview"].exists() ? jsonData["overview"].string : ""
        self.releaseDate = jsonData["release_date"].exists() ? jsonData["release_date"].string : ""
    }
}
