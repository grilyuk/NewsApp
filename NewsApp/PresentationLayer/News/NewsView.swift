import UIKit

class NewsView: UIView {
    
    // MARK: - Initializer
    
    init(article: Article) {
        self.article = article
        super.init(frame: UIScreen.main.bounds)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private properties
    
    private var article: Article
    
    private lazy var newsHeader: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = article.title
        return label
    }()
    
    private lazy var newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var newsDescription: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.text = article.description
        return textView
    }()
    
    private lazy var newsDate: UILabel = {
        let label = UILabel()
        label.text = article.publishedAt
        return label
    }()
    
    private lazy var newsSource: UILabel = {
        let label = UILabel()
        label.text = article.source?.name
        return label
    }()
    
    // MARK: - Public methods
    
    func setupUI() {
        addSubviews(newsHeader, newsImage, newsDescription, newsDate, newsSource)
        
        newsHeader.translatesAutoresizingMaskIntoConstraints = false
        newsImage.translatesAutoresizingMaskIntoConstraints = false
        newsDescription.translatesAutoresizingMaskIntoConstraints = false
        newsDate.translatesAutoresizingMaskIntoConstraints = false
        newsSource.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsHeader.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            newsHeader.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            newsHeader.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            newsHeader.heightAnchor.constraint(equalToConstant: 100),
            
            newsImage.topAnchor.constraint(equalTo: newsHeader.bottomAnchor),
            newsImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            newsImage.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
}
