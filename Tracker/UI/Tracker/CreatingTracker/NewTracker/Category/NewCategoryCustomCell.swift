import UIKit

protocol ClikerNewCategoryCell: AnyObject {
    func clikerNewCategory(_ newImage: String?, _ category: String)
}

final class NewCategoryCustomCell: UITableViewCell {
    private lazy var categorysLabel: UILabel = {
        let label = UILabel()
        label.font = .regular17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        settingsViewController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func settingsViewController() {
        contentView.addSubview(categorysLabel)
        contentView.addSubview(rightImageView)
        contentView.backgroundColor = ColorsForTheTheme.shared.table
        self.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 75),
            
            categorysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categorysLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            categorysLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rightImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightImageView.widthAnchor.constraint(equalToConstant: 24),
            rightImageView.heightAnchor.constraint(equalToConstant: 24)
            
        ])
    }
    
    func updateCategorysLabel(_ category: String) {
        categorysLabel.text = category
    }
}

extension NewCategoryCustomCell: ClikerNewCategoryCell {
    func clikerNewCategory(_ newImage: String?, _ category: String) {
        if let newImage = newImage {
            rightImageView.image = UIImage(named: newImage)
        } else {
            rightImageView.image = nil
        }
        categorysLabel.text = category
    }
}
