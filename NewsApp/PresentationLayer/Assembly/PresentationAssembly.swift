import UIKit

protocol IPresentationAssembly: AnyObject {
    func createNewsList(router: IRouter) -> NewsListViewController
    func createNewsDetails(router: IRouter, article: Article, newsImage: UIImage) -> NewsViewController
    func createFullNews(link: String) -> FullNewsViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    // MARK: - Private properties
    
    private lazy var requestFactory = RequestFactory(host: "newsapi.org/v2/")
    private lazy var networkService: INetworkService = NetworkService(urlRequestFactory: requestFactory)
    
    // MARK: - Public methods
    
    func createNewsList(router: IRouter) -> NewsListViewController {
        let presenter = NewsListPresenter()
        let view = NewsListViewController()
        presenter.networkService = networkService
        presenter.view = view
        presenter.router = router
        view.presenter = presenter
        return view
    }
    
    func createNewsDetails(router: IRouter, article: Article, newsImage: UIImage) -> NewsViewController {
        let view = NewsViewController(article: article, newImage: newsImage)
        let presenter = NewsPresenter()
        presenter.view = view
        presenter.networkService = networkService
        presenter.router = router
        view.presenter = presenter
        return view
    }
    
    func createFullNews(link: String) -> FullNewsViewController {
        FullNewsViewController(link: link)
    }
}
