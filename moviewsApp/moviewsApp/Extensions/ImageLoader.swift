

import Foundation
import Alamofire


/// clase que gestiona la descarga y guardado de imagenes en cache
class ImageLoader {
    
    static let shared = ImageLoader()
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    
    /// obitiene la imagen de una URL , la guarda en cache
    ///
    /// - Parameters:
    ///   - path: direccion donde esta la imagen
    ///   - completion: respuesta del callBack
    func loadImage(path: String, completion: @escaping (Bool, UIImage?)->Void) {
        
        if let image = imageCache.object(forKey: path as NSString) {
            completion(true, image)
        } else {
            let url = path
            Api.shared.getFilesService(url: url) { (success, data) in
                if success{
                    if let image = UIImage(data: data!){
                        self.imageCache.setObject(image, forKey: path as NSString)
                        completion(true, image)
                    }
                    else{
                        completion(false , nil)
                    }
                }
            }
        }
    }
    
    /// para obtener imagen de la cache
    ///
    /// - Returns: resultado de la busqueda
    func getImageCache()->NSCache<NSString, UIImage>{
        return self.imageCache
    }
    
    func clearCache(){
        self.imageCache.removeAllObjects()
    }
}
