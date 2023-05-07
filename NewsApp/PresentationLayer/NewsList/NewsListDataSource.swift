import UIKit

class NewsListDataSource: UITableViewDiffableDataSource<Int, UUID> {
    
    // MARK: - Initializer
    
    init(tableView: UITableView, view: INewsListView) {
        super.init(tableView: tableView) { [weak view] tableView, _, itemIdentifier in
            
            guard let model = view?.newsModels.first(where: { $0.uuid == itemIdentifier }),
                  let cell = tableView
                .dequeueReusableCell(withIdentifier: NewsListViewCell.identifier) as? NewsListViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: model)
            return cell
        }
    }
    
    func setupNewsList(news: [NewsListModel]) {
        var snapshot = snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(news.map({ $0.uuid }))
        apply(snapshot)
    }
    
    func updateImage(for cell: UUID) {
        var snapshot = snapshot()
        snapshot.reloadItems([cell])
        apply(snapshot)
    }
}
