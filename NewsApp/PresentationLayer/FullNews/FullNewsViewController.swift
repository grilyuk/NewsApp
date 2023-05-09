import UIKit
import WebKit

class FullNewsViewController: UIViewController, WKNavigationDelegate {

    // MARK: - Initialization
    
    init(link: String) {
        self.link = link
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private properties
    
    private let link: String
    private let webView = WKWebView()
    
    // MARK: - Ligecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    // MARK: - Private methods
    
    private func setupWebView() {
        webView.frame = view.bounds
        webView.navigationDelegate = self
        guard let url = URL(string: link) else {
            return
        }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        view.addSubview(webView)
    }
}
