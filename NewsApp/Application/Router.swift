import UIKit

protocol IRouter: AnyObject {
    func showNewsDetails()
}

class Router: IRouter {
    
    // MARK: - Initialization
    
    init(presentationAssembly: IPresentationAssembly, navigationController: UINavigationController) {
        self.presentationAssembly = presentationAssembly
        self.navigationController = navigationController
    }
    
    // MARK: - Public properties
    
    var presentationAssembly: IPresentationAssembly
    var navigationController: UINavigationController
    
    // MARK: - Public methods
    
    func showNewsDetails() {
        let newsDetails = presentationAssembly.createNewsDetails()
        navigationController.pushViewController(newsDetails, animated: true)
    }
}
