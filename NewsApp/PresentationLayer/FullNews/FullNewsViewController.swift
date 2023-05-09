import UIKit
import WebKit

class FullNewsViewController: UIViewController, WKNavigationDelegate {

    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    func setupWebView() {
        webView.frame = view.bounds
        webView.navigationDelegate = self
        guard let url = URL(string: "https://www.leblogauto.com/electrique/48000-euros-la-peugeot-e-308-prix-fou-94078") else {
            return
        }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        view.addSubview(webView)
    }
}
