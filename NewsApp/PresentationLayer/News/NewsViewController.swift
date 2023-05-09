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
    
    // MARK: - Private properties
    
    private var article: Article
    private var newsImage: UIImage
    private lazy var newsView = NewsView(article: article, newsImage: newsImage)

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showNewsDetail()
    }
    
    // MARK: - Actions
    
    @objc
    private func showFullNews() {
        let url = article.url
        presenter?.check(url: url) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success:
                    self?.presenter?.showFullNews(link: url ?? "")
                    self?.dismiss(animated: true)
                case .failure:
                    self?.showError()
                }
            }
        }
    }
}

// MARK: - NewsViewController + INewsView

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
            self?.dismiss(animated: true)
        }
        alert.addAction(close)
        present(alert, animated: true)
    }
}
