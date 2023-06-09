import Foundation
import CryptoKit
protocol IRequestFactory: AnyObject {
    var countOfNews: Int { get set }
    func getNews(countNews: Int) throws -> URLRequest
}

class RequestFactory: IRequestFactory {
    
    // MARK: - Initialization
    
    init(host: String) {
        self.host = host
    }
    
    // MARK: - Public properties
    
    var countOfNews = 30
    
    // MARK: - Private properties
    
    private let host: String
    
    func getNews(countNews: Int) throws -> URLRequest {
        guard let url = url(for: countNews) else {
            throw MyError.requestError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
}

private extension RequestFactory {
    private func url(for news: Int) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = "/v2/everything"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: "apple"),
            URLQueryItem(name: "sortBy", value: "publishedAt"),
            URLQueryItem(name: "apiKey", value: "4cfd82affbdf41cf93612e1f3ec71a1a"),
            URLQueryItem(name: "pageSize", value: String(news))
        ]

        guard let url = urlComponents.url else {
            return nil
        }
        print(url)
        return url
    }
}
