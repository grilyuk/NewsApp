import UIKit

struct NewsListModel {
    let newsTitle: String
    var views: Int
    var newsImage: UIImage?
    let source: String
    let article: Article
    var isDownloaded: Bool = false
    let uuid = UUID()
}
