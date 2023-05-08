import UIKit

class NewsListViewCell: UITableViewCell {

    // MARK: - UIConstants
    
    private enum UIConstant {
        static let edge: CGFloat = 5
    }
    
    // MARK: - Public properties
    
    static let identifier = String(describing: NewsListViewCell.self)
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private properties
    
    private lazy var newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var newsTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var viewsCount: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private func setupUI() {
        contentView.addSubviews(newsImage, newsTitle, viewsCount)
        
        newsImage.translatesAutoresizingMaskIntoConstraints = false
        newsTitle.translatesAutoresizingMaskIntoConstraints = false
        viewsCount.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstant.edge),
            newsImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIConstant.edge),
            newsImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstant.edge),
            newsImage.widthAnchor.constraint(equalTo: contentView.heightAnchor),
            
            newsTitle.leadingAnchor.constraint(equalTo: newsImage.trailingAnchor, constant: UIConstant.edge),
            newsTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstant.edge),
            newsTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstant.edge),
            
            viewsCount.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIConstant.edge),
            viewsCount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstant.edge)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitle.text = nil
        viewsCount.text = nil
        newsImage.image = UIImage(systemName: "photo")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    }
    
    func configure(with model: NewsListModel) {
        if model.newsImage != nil {
            newsImage.image = model.newsImage
        }
        newsTitle.text = model.newsTitle
        viewsCount.text = "Views \(model.views)"
    }
}
