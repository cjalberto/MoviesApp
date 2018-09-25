
import UIKit

class ThrillerModalViewController: UIViewController {
    
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var distanceLayout: NSLayoutConstraint!
    @IBOutlet weak var webView: UIWebView!
    var keyVideo : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.layer.borderColor = UIColor.white.cgColor
        self.webView.layer.borderWidth = 1
        self.webView.isOpaque = false
        self.webView.backgroundColor = .black
        
        self.close.layer.borderWidth = 2
        self.close.layer.borderColor = UIColor.white.cgColor
        self.close.layer.cornerRadius = self.close.frame.width/2
        self.view.makeToastActivity(self.view.center)
        
        self.setupDelegates()
    }
    
    /// cierra el modal
    ///
    /// - Parameter sender: objeto del boton de cerrar
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.keyVideo == nil{
            self.dismiss(animated: true, completion: nil)
        }
        let urlString = "\(baseURLS.thrillers.rawValue)\(keyVideo!)"
        guard let youtubeURL = URL(string: urlString) else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        if UIApplication.shared.canOpenURL(youtubeURL){
            webView.loadRequest( URLRequest(url: youtubeURL) )
        }
        
        self.distanceLayout.constant = 29
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setupDelegates() {
        self.webView.delegate = self
    }
    
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ThrillerModalViewController : UIWebViewDelegate{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.view.hideToastActivity()
    }
    
}
