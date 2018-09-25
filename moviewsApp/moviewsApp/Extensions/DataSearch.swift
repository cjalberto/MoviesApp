

import Foundation


/// clase para gestionar paginacion de servicios
class DataSearch{
    var numPages : Int = 1
    var currentPage : Int = 1
    var totalResults : Int = 0
    
    init(numPages : Int , totalResults : Int) {
        self.currentPage = 1
        self.numPages = numPages
        self.totalResults = totalResults
    }
    
    init() {
    }
}
