import UIKit

protocol INewsListView: AnyObject {
    var newsModels: [NewsListModel] { get set }
    func showNews(models: [NewsListModel])
}

class NewsListViewController: UIViewController {
    
    typealias DataSource = NewsListDataSource
    
    // MARK: - Public properties
    
    var presenter: INewsListPresenter? = NewsListPresenter()
    var newsModels: [NewsListModel] = []
    
    // MARK: - Private properties
    
    private lazy var newsListView = NewsListView()
    private lazy var dataSource = DataSource(tableView: newsListView.tableView, view: self)
    
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
    }
    
    // MARK: - Private methods
    
    private func setupNavigationBar() {
        self.title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray4
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
}

extension NewsListViewController: INewsListView {
    func showNews(models: [NewsListModel]) {
        dataSource.setupNewsList(news: models)
    }
}

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIScreen.main.bounds.height / 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = dataSource.snapshot().itemIdentifiers[indexPath.row]
//        newsModels.first(where: {$0.uuid == cell})
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
