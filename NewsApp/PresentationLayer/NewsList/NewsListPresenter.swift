import UIKit

protocol INewsListPresenter: AnyObject {
    func uploadData(countOfNews: Int, completion: @escaping ([NewsListModel]) -> Void)
    func downloadImage(for article: Article)
    func showNewsDetail(article: Article, newsImage: UIImage)
}

class NewsListPresenter: INewsListPresenter {
    
    // MARK: - Public properties
    
    weak var view: INewsListView?
    var router: IRouter?
    var networkService: INetworkService?
    var modelsToView: [NewsListModel] = []
    
    // MARK: - Private properties
    
    private let mainQueue = DispatchQueue.main
    private let backgroundQueue = DispatchQueue.global(qos: .userInitiated)
    
    // MARK: - Public properties
    
    func uploadData(countOfNews: Int, completion: @escaping ([NewsListModel]) -> Void) {
        networkService?.getNews(countNews: countOfNews) { [weak self] result in
            
            switch result {
                
            case .success(let newsModel):

                self?.convertModels(networkModel: newsModel, completion: completion)
                
            case .failure:
                self?.mainQueue.async {
                    self?.view?.showError()
                }
            }
        }
    }
    
    func downloadImage(for article: Article) {
        
        guard let imageUrl = article.urlToImage else {
            return
        }
        
        networkService?.getImage(url: imageUrl) { [weak self] result in
            switch result {
                
            case .success(let newsImage):
                guard let self,
                      let index = self.view?.newsModels.firstIndex(where: { $0.newsTitle == article.title ?? "" }),
                      let id = self.view?.newsModels[index].uuid else {
                    return
                }
                
                self.view?.newsModels[index].newsImage = newsImage
                self.view?.newsModels[index].isDownloaded = true
                
                self.mainQueue.async { [weak self] in
                    self?.view?.updateCells(id: id)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func showNewsDetail(article: Article, newsImage: UIImage) {
        router?.showNewsDetails(article: article, newsImage: newsImage)
    }
    
    // MARK: - Private properties
    
    private func convertModels(networkModel: NewsListModelNetwork, completion: @escaping ([NewsListModel]) -> Void) {
        
        networkModel.articles.forEach { article in

            let newsModel = NewsListModel(newsTitle: article.title ?? "",
                                          views: 0,
                                          newsImage: nil,
                                          source: article.url ?? "",
                                          article: article)
            
            if !modelsToView.contains(where: { $0.article.url == newsModel.article.url }) {
                modelsToView.append(newsModel)
            }
        }
        mainQueue.async { [weak self] in
            guard let self else {
                return
            }
            completion(modelsToView)
        }
    }
}
