import UIKit

class NewsListView: UIView {
    
    typealias DataSource = NewsListDataSource
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: UIScreen.main.bounds)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private properties
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    // MARK: - Public methods
    
    func setupUI() {
        addSubview(tableView)
        setupConstraints()
    }
    
    // MARK: - Private methods
    
    private func setupConstraints() {
        backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
