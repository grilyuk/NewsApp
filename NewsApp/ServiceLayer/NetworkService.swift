import UIKit

protocol INetworkService: AnyObject {
    func getNews(completion: @escaping (Result<NewsListModelNetwork, Error>) -> Void)
    func getImage(url: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

class NetworkService: INetworkService {
    
    // MARK: - Initialization
    
    init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.urlCache = URLCache(memoryCapacity: 50 * 1024 * 1024,
                                          diskCapacity: 100 * 1024 * 1024,
                                          diskPath: "NewsCache")
        let session = URLSession(configuration: configuration)
        self.session = session
    }
    
    // MARK: - Private properties
    
    private var session: URLSession
    
    // MARK: - Public methods
    
    func getNews(completion: @escaping (Result<NewsListModelNetwork, Error>) -> Void) {
        
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=tesla&sortBy=publishedAt&apiKey=d7fa48123fe8427e96f1166508c58d76&pageSize=20") else {
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
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
                return
            }
            
            if let image = UIImage(data: data) {
                completion(.success(image))
            }
        }.resume()
    }
}
