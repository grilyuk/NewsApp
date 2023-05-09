import UIKit

class NewsView: UIView {
    
    // MARK: - Initializer
    
    init(article: Article, newsImage: UIImage) {
        self.article = article
        self.fullNewsImage = newsImage
        super.init(frame: UIScreen.main.bounds)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIConstants
    
    private enum UIConstants {
        static let edge: CGFloat = 10
    }
    
    // MARK: - Public properties
    
    lazy var newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.image = fullNewsImage
        imageView.sizeToFit()
        return imageView
    }()
    
    lazy var openLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open full news", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.layoutIfNeeded()
        return button
    }()
    
    // MARK: - Private properties
    
    private var article: Article
    private var fullNewsImage: UIImage
    
    private lazy var newsHeader: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = article.title
        label.backgroundColor = .secondarySystemBackground
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.font = .boldSystemFont(ofSize: 25)
        label.numberOfLines = 0
        label.layoutIfNeeded()
        return label
    }()
    
    private lazy var newsDescription: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.text = article.description
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 18)
        textView.layoutIfNeeded()
        textView.isScrollEnabled = false
        return textView
    }()
    
    private lazy var newsDate: UILabel = {
        let label = UILabel()
        label.text = "Publication time: \(article.publishedAt ?? "")"
        return label
    }()
    
    private lazy var newsSource: UILabel = {
        let label = UILabel()
        label.text = "Source: \(article.source?.name ?? "")"
        label.textColor = .lightGray
        return label
    }()

    // MARK: - Public methods
    
    func setupUI() {
        addSubviews(newsHeader, newsImage, newsDescription, newsDate, newsSource, openLinkButton)
        
        newsHeader.translatesAutoresizingMaskIntoConstraints = false
        newsImage.translatesAutoresizingMaskIntoConstraints = false
        newsDescription.translatesAutoresizingMaskIntoConstraints = false
        newsDate.translatesAutoresizingMaskIntoConstraints = false
        newsSource.translatesAutoresizingMaskIntoConstraints = false
        openLinkButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsHeader.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: UIConstants.edge),
            newsHeader.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIConstants.edge),
            newsHeader.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UIConstants.edge),
            
            newsImage.topAnchor.constraint(equalTo: newsHeader.bottomAnchor, constant: UIConstants.edge),
            newsImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            newsImage.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, multiplier: 0.25),

            newsDescription.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: UIConstants.edge),
            newsDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIConstants.edge),
            newsDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UIConstants.edge),
            newsDescription.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, multiplier: 0.5),
            
            newsDate.topAnchor.constraint(equalTo: newsDescription.bottomAnchor, constant: UIConstants.edge),
            newsDate.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UIConstants.edge),
            
            newsSource.topAnchor.constraint(equalTo: newsDate.bottomAnchor, constant: UIConstants.edge),
            newsSource.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UIConstants.edge),
            
            openLinkButton.topAnchor.constraint(equalTo: newsSource.bottomAnchor, constant: UIConstants.edge),
            openLinkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UIConstants.edge),
            openLinkButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            openLinkButton.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
            openLinkButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.05)
        ])
    }
}
