import Foundation

protocol INewsPresenter: AnyObject {
    func showFullNews(url: String)
}

class NewsPresenter: INewsPresenter {
    
    weak var view: INewsView?
    weak var router: IRouter?
    var networkService: INetworkService?
    
    func showFullNews(url: String) {
        
    }
}
