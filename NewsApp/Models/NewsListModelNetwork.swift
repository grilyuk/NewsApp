import Foundation

// MARK: - News

struct NewsListModelNetwork: Decodable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]
}

// MARK: - Article

struct Article: Decodable {
    let source: Source?
    let author: String?
    let title, description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

// MARK: - Source

struct Source: Decodable {
    let id: String?
    let name: String?
}
