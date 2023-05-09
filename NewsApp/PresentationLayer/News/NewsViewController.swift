import UIKit

protocol INewsView {
    func showNewsDetail()
    func showError()
}

class NewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showNewsDetail()
    }
}

extension NewsViewController: INewsView {
    func showNewsDetail() {
        let newsView = NewsView(article: Article(source: Source(id: "", name: ""),
                                                 author: "", title: "TTTTEST", description: "",
                                                 url: "", urlToImage: "", publishedAt: "", content: ""))
        self.view = newsView
        newsView.setupUI()
    }
    
    func showError() {
        let alert = UIAlertController(title: "Something wrong",
                                      message: "Try later",
                                      preferredStyle: .alert)
        let close = UIAlertAction(title: "Close", style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(close)
        present(alert, animated: true)
    }
}
