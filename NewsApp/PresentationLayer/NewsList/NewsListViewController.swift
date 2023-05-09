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
    
    private lazy var background = DispatchQueue.global(qos: .default)
    private lazy var newsListView = NewsListView()
    private lazy var dataSource = DataSource(tableView: newsListView.tableView, view: self)
    private lazy var pullToRefresh = UIRefreshControl()
    private lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = newsListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshBarButton: UIBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.leftBarButtonItem = refreshBarButton
        activityIndicator.startAnimating()
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
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray4
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // MARK: - Actions
    
    @objc
    private func updateNews() {
        presenter?.uploadData { [weak self] models in
            models.forEach { [weak self] model in
                guard let self else { return }
                if !self.newsModels.contains(where: { model.source == $0.source }) {
                    self.newsModels.append(contentsOf: models)
                    self.appendNews(news: models)
                }
            }
        }
        pullToRefresh.endRefreshing()
    }
    
}

// MARK: - NewsListViewController + INewsListView

extension NewsListViewController: INewsListView {
    
    func showNews(models: [NewsListModel]) {
        activityIndicator.stopAnimating()
        self.title = "News"
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
        dataSource.updateData(for: id)
    }
}

// MARK: - NewsListViewController + UITableViewDelegate

extension NewsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIScreen.main.bounds.height / 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = dataSource.snapshot().itemIdentifiers[indexPath.row]
        guard let article = newsModels.first(where: { $0.uuid == cell })?.article,
              let index = newsModels.firstIndex(where: { $0.uuid == cell }) else {
            return
        }

        if let newsImage = newsModels.first(where: { $0.uuid == cell })?.newsImage {
            presenter?.showNewsDetail(article: article, newsImage: newsImage)
        } else {
            let newsImage = UIImage(systemName: "photo")?.withTintColor(.lightGray)
                .scalePreservingAspectRatio(targetSize: view.bounds.size) ?? UIImage()
            presenter?.showNewsDetail(article: article, newsImage: newsImage)
        }
        newsModels[index].views += 1
        dataSource.updateData(for: newsModels[index].uuid)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        background.async { [weak self] in
            guard let self else { return }
            let cell = dataSource.snapshot().itemIdentifiers[indexPath.row]
            guard let index = newsModels.firstIndex(where: { $0.uuid == cell }),
                  !newsModels[index].isDownloaded else {
                return
            }
            presenter?.downloadImage(for: newsModels[index].article)
            newsModels[index].isDownloaded = true
        }
    }
}
