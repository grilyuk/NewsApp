import UIKit

protocol INewsListPresenter: AnyObject {
    func uploadData(completion: @escaping ([NewsListModel]) -> Void)
}

class NewsListPresenter: INewsListPresenter {
    
    // MARK: - Public properties
    
    weak var view: INewsListView?
    var networkService: INetworkService = NetworkService()
    var modelsToView: [NewsListModel] = []
    
    // MARK: - Public properties
    
    func uploadData(completion: @escaping ([NewsListModel]) -> Void) {
        networkService.getNews { [weak self] result in
            
            switch result {
            case .success(let newsModel):
                self?.convertModels(networkModel: newsModel, completion: completion)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    // MARK: - Private properties
    
    private func convertModels(networkModel: NewsListModelNetwork, completion: @escaping ([NewsListModel]) -> Void) {
        
        networkModel.articles.forEach { article in
            
            let newsModel = NewsListModel(newsTitle: article.title ?? "",
                                          views: 0,
                                          newsImage: nil)
            modelsToView.append(newsModel)
            completion(modelsToView)
            
            downloadImage(for: article)
        }
    }
    
    private func downloadImage(for article: Article) {
        
        guard let imageUrl = article.urlToImage else {
            return
        }
        
        networkService.getImage(url: imageUrl) { [weak self] result in
            switch result {
                
            case .success(let newsImage):
                guard let self,
                      let index = self.view?.newsModels.firstIndex(where: { $0.newsTitle == article.title ?? "" }),
                      let id = self.view?.newsModels[index].uuid else {
                    return
                }
                
                self.view?.newsModels[index].newsImage = newsImage
                
                self.view?.updateCells(id: id)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
