import Foundation

protocol INewsPresenter: AnyObject {
    func check(url: String?, completion: @escaping (Result<Void, Error>) -> Void)
    func showFullNews(link: String)
}

class NewsPresenter: INewsPresenter {
    
    // MARK: - Public properties
    
    weak var view: INewsView?
    weak var router: IRouter?
    var networkService: INetworkService?
    
    // MARK: - Public methods
    
    func check(url: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        networkService?.checkUrlResponse(url: url, completion: completion)
    }
    
    func showFullNews(link: String) {
        router?.showFullNews(link: link)
    }
}
