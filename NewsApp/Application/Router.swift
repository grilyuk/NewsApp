import UIKit

protocol IRouter: AnyObject {
    func showNewsDetails(article: Article, newsImage: UIImage)
    func showFullNews(link: String)
}

class Router: IRouter {
    
    // MARK: - Initialization
    
    init(presentationAssembly: IPresentationAssembly, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.presentationAssembly = presentationAssembly
    }
    
    // MARK: - Public properties
    
    var presentationAssembly: IPresentationAssembly?
    var navigationController: UINavigationController
    
    // MARK: - Public methods
    
    func initialController() {
        if let newsList = presentationAssembly?.createNewsList(router: self) {
            navigationController.viewControllers = [newsList]
        }
    }
    
    func showNewsDetails(article: Article, newsImage: UIImage) {
        if let newsDetails = presentationAssembly?.createNewsDetails(router: self, article: article, newsImage: newsImage) {
            navigationController.present(newsDetails, animated: true)
        }
    }
    
    func showFullNews(link: String) {
        if let fullNews = presentationAssembly?.createFullNews(link: link) {
            navigationController.pushViewController(fullNews, animated: true)
        }
    }
}
