import UIKit

protocol IRouter: AnyObject {
    func showNewsDetails(article: Article, newsImage: UIImage, navigationController: UINavigationController)
}

class Router: IRouter {
    
    // MARK: - Initialization
    
    init(presentationAssembly: IPresentationAssembly) {
        self.presentationAssembly = presentationAssembly
    }
    
    // MARK: - Public properties
    
    weak var presentationAssembly: IPresentationAssembly?
    
    // MARK: - Public methods
    
    func showNewsDetails(article: Article, newsImage: UIImage, navigationController: UINavigationController) {
        guard let newsDetails = presentationAssembly?.createNewsDetails(article: article, newsImage: newsImage) else {
            return
        }
        navigationController.pushViewController(newsDetails, animated: true)
    }
}
