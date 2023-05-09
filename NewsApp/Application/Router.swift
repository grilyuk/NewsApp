import UIKit

protocol IRouter: AnyObject {
    func showNewsDetails(article: Article, newsImage: UIImage)
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
        if let newsDetails = presentationAssembly?.createNewsDetails(article: article, newsImage: newsImage) {
            navigationController.pushViewController(newsDetails, animated: true)
        }
    }
}
