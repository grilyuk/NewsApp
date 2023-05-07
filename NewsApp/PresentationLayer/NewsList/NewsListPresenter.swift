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
            
            downloadImage(for: article, completion: completion)
        }
    }
    
    private func downloadImage(for article: Article, completion: @escaping ([NewsListModel]) -> Void) {
        
        guard let imageUrl = article.urlToImage else {
            return
        }
        
        networkService.getImage(url: imageUrl) { [weak self] result in
            switch result {
            case .success(let newsImage):
                guard let index = self?.modelsToView.firstIndex(where: { $0.newsTitle == article.title }) else {
                    return
                }
                self?.modelsToView[index].newsImage = newsImage
                DispatchQueue.main.async {
                    completion(self?.modelsToView ?? [])
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
