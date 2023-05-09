import Foundation

protocol IRequestFactory: AnyObject {
    func getNews() throws -> URLRequest
}

class RequestFactory: IRequestFactory {
    
    // MARK: - Initialization
    
    init(host: String) {
        self.host = host
    }
    
    // MARK: - Private properties
    
    private let host: String
    
    func getNews() throws -> URLRequest {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=tesla&sortBy=publishedAt&apiKey=d7fa48123fe8427e96f1166508c58d76&pageSize=40") else {
            throw MyError.requestError
        }
        
        return URLRequest(url: url)
    }
    
}

private extension RequestFactory {
    private func url(with path: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        guard let url = urlComponents.url else {
            return nil
        }
        print(url)
        return url
    }
}
