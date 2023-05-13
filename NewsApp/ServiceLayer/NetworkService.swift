import UIKit

protocol INetworkService: AnyObject {
    func getNews(countNews: Int, completion: @escaping (Result<NewsListModelNetwork, Error>) -> Void)
    func getImage(url: String, completion: @escaping (Result<UIImage, Error>) -> Void)
    func checkUrlResponse(url: String?, completion: @escaping (Result<Void, Error>) -> Void)
}

class NetworkService: INetworkService {
    
    // MARK: - Initialization
    
    init(urlRequestFactory: IRequestFactory) {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.urlCache = URLCache(memoryCapacity: 50 * 1024 * 1024,
                                          diskCapacity: 100 * 1024 * 1024,
                                          diskPath: "networkCache")

        let session = URLSession(configuration: configuration)
        self.session = session
        self.urlRequestFactory = urlRequestFactory
    }
    
    // MARK: - Private properties
    
    private var session: URLSession
    private var urlRequestFactory: IRequestFactory
    
    // MARK: - Public methods
    
    func getNews(countNews: Int, completion: @escaping (Result<NewsListModelNetwork, Error>) -> Void) {

        let urlRequest = try? urlRequestFactory.getNews(countNews: countNews)
        
        guard let urlRequest else { return }
        
        session.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse,
                  let data = data else {
                return
            }
            
            if response.statusCode != 404 {
                do {
                    let newsModel = try JSONDecoder().decode(NewsListModelNetwork.self, from: data)
                    completion(.success(newsModel))
                } catch {
                    completion(.failure(error))
                }
                
            }
        }.resume()
    }
    
    func getImage(url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        session.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else {
                completion(.failure(MyError.requestError))
                return
            }
            
            if var image = UIImage(data: data) {
                image = image.scalePreservingAspectRatio(targetSize: CGSize(width: 400, height: 400))
                completion(.success(image))
            }
        }.resume()
    }
    
    func checkUrlResponse(url: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let url = URL(string: url ?? "") else {
            completion(.failure(MyError.requestError))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        session.dataTask(with: urlRequest) { _, response, error in
            if let error {
                completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(MyError.requestError))
                return
            }
            
            if response.statusCode != 200 {
                completion(.failure(MyError.requestError))
            } else {
                completion(.success(()))
            }
        }.resume()
    }
}
