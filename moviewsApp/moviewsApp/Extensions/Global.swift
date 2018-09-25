import Foundation
import UIKit


/// url base de los servicios que se usan en la app
///
/// - Movies: url base para consumir los servicios que traen las peliculas
/// - posters: url base para traer los poster de las peliculas
/// - genres: url base para traer los generos de las peliculas
/// - thrillers: url base para traer los trailers de youtube
/// - Search: url base para traer las peliculas del buscador online
enum baseURLS : String{
    case Movies = "https://api.themoviedb.org/3/movie/"
    case posters = "https://image.tmdb.org/t/p/w150_and_h225_bestv2/"
    case genres = "https://api.themoviedb.org/3/genre/movie/list"
    case thrillers = "https://www.youtube.com/embed/"
    case Search = "https://api.themoviedb.org/3/search/movie"
}


/// tipos de categoria de listados de peliculas
///
/// - popular: peliculas populares
/// - top: peliculas mejor votadas
/// - upcoming: peliculas por venir
enum Category : String{
    case popular = "popular"
    case top = "top_rated"
    case upcoming = "upcoming"
    
    static let allValues = [popular, top, upcoming]
    
    init?(id : Int) {
        switch id {
        case 1: self = .popular
        case 2: self = .top
        case 3: self = .upcoming
        default: return nil
        }
    }
}


/// lenguaje con el que se trae la informacion del server
///
/// - english: idioma ingles
/// - spanish: idioma espanol
enum Language : String {
    case english = "en-US"
    case spanish = "es"
}

