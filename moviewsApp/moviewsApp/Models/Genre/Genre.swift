
import Foundation
import SwiftyJSON

class Genre: NSObject {
    
    static var genres : [Genre] = []
    
    public var id: Int
    public var name: String?
    
    init(jsonData : JSON) {
        
        self.name = jsonData["name"].exists() ? jsonData["name"].string : ""
        self.id = jsonData["id"].exists() ? jsonData["id"].int! : 0
    }
    
    static func loadGenres(){
        Api.shared.getDataService(typeService: .genres) { (success, dataJson, error) in
            if success{
                guard let array = dataJson?["genres"].array else{
                    return
                }
                for item in array{
                    self.genres.append(Genre(jsonData: item))
                }
            }
            else{
                
            }
        }
    }
}
