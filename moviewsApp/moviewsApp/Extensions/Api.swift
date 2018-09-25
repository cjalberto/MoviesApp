import Foundation
import Alamofire
import SwiftyJSON



/// clase que gastiona las peticiones a al servidor de the movies db
class Api {
    
    static let shared: Api = Api()
    var alamoFireManager : SessionManager?
    fileprivate let apiKey : String = "b9d86c5962d09963a27e22e4949e2833"
    fileprivate var currentLanguage : Language = .english
    
    init() {
        self.alamofire()
    }
    
    
    func alamofire(){
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        alamoFireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    
    /// Metodo que realiza peticiones al server con respuestas JSON
    ///
    /// - Parameters:
    ///   - infoRequest: informacion para armar la peticion que se desea realizar
    ///   - typeService: tipo de peticion que se va a realizar
    ///   - completion: respuesta del server
    func getDataService(infoRequest : [String : Any]? = nil , typeService : baseURLS , completion:@escaping (Bool , JSON? , Error?) ->()) {
    
        guard let url = Api.createUrl(infoRequest: infoRequest, typeService: typeService) else{
            return
        }
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type":"application/json"
        ]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON  { response in
            
            switch(response.result) {
            case .success(_):
                if response.response?.statusCode == 200{
                    let json = JSON(response.result.value as Any)
                    return completion(true , json, nil)
                }
            case .failure(_):
                return completion(false, nil, response.error)
            }
        }
    }
    
    
    /// Metodo que realiza peticiones al server con respuestas Data
    ///
    /// - Parameters:
    ///   - url: url del servicio
    ///   - completion: respuesta del server
    func getFilesService(url : String , completion:@escaping (Bool, Data?) ->()) {
        Alamofire.request(url).responseData { (response) in
            if response.error == nil{
                if let data = response.data{
                    return completion(true , data)
                }
                return completion(false , nil)
            }
            else{
                return completion(false, nil)
            }
        }
    }

    /// Metodo que arma la url para la peticion
    ///
    /// - Parameters:
    ///   - infoRequest: informacion para armar la url
    ///   - typeService: tipo de peticion que se va a realizar
    /// - Returns: url del servicio
    class func createUrl(infoRequest : [String : Any]? = nil , typeService : baseURLS) -> String?{
        switch typeService {
        case .Movies:
            if let info =  infoRequest{
                guard let page = info["page"] as? Int , let path = info["category"] as? String else {
                    return nil
                }
                return "\(typeService.rawValue)\(path)?api_key=\(Api.shared.apiKey)&language=\(Api.shared.currentLanguage.rawValue)&page=\(page)"
            }
            return nil
        case .Search:
            if let info =  infoRequest{
                guard let page = info["page"] as? Int , let query = info["query"] as? String else {
                    return nil
                }
                return "\(typeService.rawValue)?api_key=\(Api.shared.apiKey)&language=\(Api.shared.currentLanguage.rawValue)&page=\(page)&include_adult=false&query=\(query)"
            }
            return nil
        case .posters:
            if let info =  infoRequest{
                guard let posterPath = info["posterPath"] as? String else {
                    return nil
                }
                return "\(typeService.rawValue)\(posterPath)"
            }
            return nil
        case .genres:
            return "\(typeService.rawValue)?api_key=\(Api.shared.apiKey)&language=\(Api.shared.currentLanguage.rawValue)"
        case .thrillers:
            if let info =  infoRequest{
                guard let movieId = info["id"] as? String else {
                    return nil
                }
                return "\(baseURLS.Movies.rawValue)\(movieId)/videos?api_key=\(Api.shared.apiKey)&language=\(Api.shared.currentLanguage.rawValue)"
            }
            return nil
        }
    }
    
    
    /// metodo que verifica si hay conexion a internet
    ///
    /// - Returns: respuesta de la verificacion
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

