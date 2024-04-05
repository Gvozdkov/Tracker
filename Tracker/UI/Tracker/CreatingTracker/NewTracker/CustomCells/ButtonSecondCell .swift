import UIKit

final class ButtonSecondCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableKeys.schedules
        label.font = .regular17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subSchedule = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .regular17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, subSchedule ])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "forwardNavigation")
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
        contentView.addSubview(stackView)
        contentView.addSubview(rightImageView)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 75),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rightImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightImageView.widthAnchor.constraint(equalToConstant: 24),
            rightImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func cellSettings(subSchedule: String?) {
        self.subSchedule .text = subSchedule
    }
}


