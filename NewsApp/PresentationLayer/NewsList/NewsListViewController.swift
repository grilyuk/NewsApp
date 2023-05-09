import UIKit

protocol INewsListView: UIViewController {
    var newsModels: [NewsListModel] { get set }
    func showNews(models: [NewsListModel])
    func showError()
    func updateCells(id: UUID)
}

class NewsListViewController: UIViewController {
    
    typealias DataSource = NewsListDataSource
    
    // MARK: - Public properties
    
    var presenter: INewsListPresenter?
    var newsModels: [NewsListModel] = []
    
    // MARK: - Private properties
    
    private lazy var newsListView = NewsListView()
    private lazy var dataSource = DataSource(tableView: newsListView.tableView, view: self)
    private lazy var pullToRefresh = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = newsListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.uploadData(completion: { [weak self] models in
            self?.newsModels = models
            self?.showNews(models: models)
        })
        newsListView.setupUI()
        setupNavigationBar()
        newsListView.tableView.register(NewsListViewCell.self,
                                        forCellReuseIdentifier: NewsListViewCell.identifier)
        newsListView.tableView.dataSource = dataSource
        newsListView.tableView.delegate = self
        newsListView.tableView.addSubview(pullToRefresh)
        pullToRefresh.addTarget(self, action: #selector(updateNews), for: .valueChanged)
    }
    
    // MARK: - Private methods
    
    private func setupNavigationBar() {
        self.title = "News"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray4
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc
    private func updateNews() {
        presenter?.uploadData(completion: { [weak self] models in
            models.forEach { [weak self] model in
                guard let self else { return }
                if !self.newsModels.contains(where: { model.source == $0.source }) {
                    self.newsModels.append(contentsOf: models)
                    self.appendNews(news: models)
                }
            }
        })
        pullToRefresh.endRefreshing()
    }
    
}

extension NewsListViewController: INewsListView {
    
    func showNews(models: [NewsListModel]) {
        dataSource.setupNewsList(news: models)
    }
    
    func showError() {
        let alert = UIAlertController(title: "Something error 😬", message: "Maybe retry?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let retry = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.presenter?.uploadData(completion: { [weak self] models in
                self?.newsModels = models
                self?.showNews(models: models)
            })
        }
        alert.addAction(retry)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func appendNews(news: [NewsListModel]) {
        dataSource.appendNewsCells(news: news)
    }
    
    func updateCells(id: UUID) {
        dataSource.updateImage(for: id)
    }
}

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIScreen.main.bounds.height / 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = dataSource.snapshot().itemIdentifiers[indexPath.row]
        guard let article = newsModels.first(where: { $0.uuid == cell })?.article,
              let navigationController = self.navigationController else {
            return
        }
        
        if let newsImage = newsModels.first(where: { $0.uuid == cell })?.newsImage {
            presenter?.showNewsDetail(article: article, newsImage: newsImage, navigationController: navigationController)
        } else {
            let newsImage = UIImage(systemName: "photo")?.withTintColor(.lightGray)
                .scalePreservingAspectRatio(targetSize: view.bounds.size) ?? UIImage()
            presenter?.showNewsDetail(article: article, newsImage: newsImage, navigationController: navigationController)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let cell = dataSource.snapshot().itemIdentifiers[indexPath.row]
            guard let model = newsModels.first(where: { $0.uuid == cell }),
                  !model.isDownloaded
            else {
                return
            }
            presenter?.downloadImage(for: model.article)
        }
    }
}
