import UIKit

protocol IPresentationAssembly: AnyObject {
    func createNewsList() -> UINavigationController
    func createNewsDetails(article: Article, newsImage: UIImage) -> NewsViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    private lazy var router = Router(presentationAssembly: self)
    private lazy var requestFactory = RequestFactory(host: "newsapi.org/v2/")
    private lazy var networkService: INetworkService = NetworkService(urlRequestFactory: requestFactory)
    
    func createNewsList() -> UINavigationController {
        let presenter = NewsListPresenter()
        let view = NewsListViewController()
        presenter.networkService = networkService
        presenter.view = view
        presenter.router = router
        view.presenter = presenter
        let navigationController = UINavigationController(rootViewController: view)
        return navigationController
    }
    
    func createNewsDetails(article: Article, newsImage: UIImage) -> NewsViewController {
        let view = NewsViewController(article: article, newImage: newsImage)
        let presenter = NewsPresenter()
        presenter.router = router
        presenter.view = view
        view.presenter = presenter
        return view
    }
    
    func createFullNews() {
        
    }
}
