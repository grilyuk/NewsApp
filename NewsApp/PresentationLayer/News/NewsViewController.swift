import UIKit

protocol INewsView: UIViewController {
    func showNewsDetail()
    func showError()
}

class NewsViewController: UIViewController {
    
    // MARK: - Initialization
    
    init(article: Article, newImage: UIImage) {
        self.article = article
        self.newsImage = newImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public properties
    
    var presenter: INewsPresenter?
    private var article: Article
    private var newsImage: UIImage
    
    private lazy var newsView = NewsView(article: article, newsImage: newsImage)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showNewsDetail()
    }
    
    @objc
    private func showFullNews() {
//        presenter?.showFullNews(url: article.url ?? "")
    }
}

extension NewsViewController: INewsView {
    func showNewsDetail() {
        self.view = newsView
        newsView.setupUI()
        newsView.openLinkButton.addTarget(self, action: #selector(showFullNews), for: .touchUpInside)
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
