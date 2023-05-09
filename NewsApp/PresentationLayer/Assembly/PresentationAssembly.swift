import UIKit

protocol IPresentationAssembly: AnyObject {
    func createNewsList() -> UINavigationController
    func createNewsDetails() -> NewsViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    private lazy var requestFactory = RequestFactory(host: "newsapi.org/v2/")
    private lazy var networkService: INetworkService = NetworkService(urlRequestFactory: requestFactory)
    
    func createNewsList() -> UINavigationController {
        let presenter = NewsListPresenter()
        let view = NewsListViewController()
        presenter.networkService = networkService
        presenter.view = view
        view.presenter = presenter
        let navigationController = UINavigationController(rootViewController: view)
        let router = Router(presentationAssembly: self, navigationController: navigationController)
        presenter.router = router
        return navigationController
    }
    
    func createNewsDetails() -> NewsViewController {
        let view = NewsViewController()
        return view
    }
}
