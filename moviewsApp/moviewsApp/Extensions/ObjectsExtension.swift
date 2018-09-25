

import Foundation
import UIKit
import Toast_Swift

extension UIViewController{
    
    /// realiza la navegacion hacia la interfaz de detalle de pelicula
    ///
    /// - Parameter movie: data de la pelicula
    func goToMovieDetail(movie : Movie){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "movie-detail-controller") as! MovieDetailViewController
        vc.movie = movie
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /// dirige la navegacionn a la interfaz del buscador online
    func goToSearch(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "search-view-controller") as! SearchMoviesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    /// muestra el modal de lal thriller
    ///
    /// - Parameter key: key del video en youtube
    func showThriller(key : String){
        guard let presentedViewController = self.storyboard?.instantiateViewController(withIdentifier: "ThrillerModal") as? ThrillerModalViewController else{
            self.view.makeToast("Error loading video")
            return
        }
        presentedViewController.keyVideo = key
        presentedViewController.providesPresentationContextTransitionStyle = true
        presentedViewController.definesPresentationContext = true
        presentedViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        presentedViewController.modalTransitionStyle = .crossDissolve
        self.present(presentedViewController, animated: true, completion: nil)
    }
}


extension UIImageView {
    
    
    /// carga la imagen en el componente
    ///
    /// - Parameter path: direccion URL de la imagen
    func loadPicture(of path: String) {
        self.makeToastActivity(self.center)
        if let url = URL(string: path){
            if UIApplication.shared.canOpenURL(url){
                ImageLoader.shared.loadImage(path: path) {(success, image) in
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.hideToastActivity()
                        if success {
                            self.image = image
                        }
                    })
                }
            }
        }
    }
}

