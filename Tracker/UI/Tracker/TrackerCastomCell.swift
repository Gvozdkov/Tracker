import UIKit

protocol TrackerCellDelegate: AnyObject {
    func trackerRecord(tracker: Tracker)
}

final class TrackerCastomCell: UICollectionViewCell {
    weak var delegate: TrackerCellDelegate?
    
    private lazy var frameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = .blue
        return view
    }()
    
    private lazy var gradient: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        label.textAlignment = .center
        label.font = .medium12
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .medium12
        label.textColor = .white
        return label
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .medium12
        label.textColor = ColorsForTheTheme.shared.buttonAction
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        button.backgroundColor = .blue
        button.tintColor = .white
        return button
    }()
    
    private lazy var pinImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var imageButton = UIImage(systemName: "plus")
    
    private var tracker: Tracker = Tracker(id: UUID(), name: "", emoji: "", color: .black, schedule: [], isPin: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraintsSettingsView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        assertionFailure("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    private func constraintsSettingsView() {
        frameView.addSubview(colorView)
        colorView.addSubview(pinImage)
        colorView.addSubview(gradient)
        colorView.addSubview(nameLabel)
        colorView.addSubview(emojiLabel)
        gradient.addSubview(emojiLabel)
        frameView.addSubview(dayLabel)
        frameView.addSubview(button)
        
        contentView.addSubview(frameView)
        
        NSLayoutConstraint.activate([
            frameView.widthAnchor.constraint(equalToConstant: 167),
            frameView.heightAnchor.constraint(equalToConstant: 148),
            
            colorView.leadingAnchor.constraint(equalTo: frameView.leadingAnchor),
            colorView.topAnchor.constraint(equalTo: frameView.topAnchor),
            colorView.trailingAnchor.constraint(equalTo: frameView.trailingAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 167),
            colorView.heightAnchor.constraint(equalToConstant: 90),
            
            pinImage.topAnchor.constraint(equalTo: frameView.topAnchor, constant: 12),
            pinImage.trailingAnchor.constraint(equalTo: frameView.trailingAnchor, constant: -4),
            pinImage.widthAnchor.constraint(equalToConstant: 24),
            pinImage.heightAnchor.constraint(equalToConstant: 24),
            
            gradient.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            gradient.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            gradient.widthAnchor.constraint(equalToConstant: 24),
            gradient.heightAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: gradient.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: gradient.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 44),
            nameLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12),
            nameLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            nameLabel.widthAnchor.constraint(equalToConstant: 143),
            nameLabel.heightAnchor.constraint(equalToConstant: 34),
            
            dayLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            dayLabel.leadingAnchor.constraint(equalTo: frameView.leadingAnchor, constant: 12),
            dayLabel.widthAnchor.constraint(equalToConstant: 101),
            dayLabel.heightAnchor.constraint(equalToConstant: 18),
            
            button.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: frameView.trailingAnchor, constant: -12),
            button.widthAnchor.constraint(equalToConstant: 34),
            button.heightAnchor.constraint(equalToConstant: 34),
        ])
    }
    
    func updateData(tracker: Tracker, click: Bool, counterDays: String) {
        colorView.backgroundColor = tracker.color
        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.name
        button.backgroundColor = tracker.color
        dayLabel.text = counterDays
        self.tracker = tracker
        
        if tracker.isPin {
            pinImage.image = UIImage(named: "Pin")
        } else {
            pinImage.image = nil
        }
        
        
        switch click {
        case true:
            button.alpha = 0.3
            imageButton = UIImage(systemName: "checkmark")
            button.setImage(imageButton, for: .normal)
            
        case false:
            button.alpha = 1
            imageButton = UIImage(systemName: "plus")
            button.setImage(imageButton, for: .normal)
        }
    }
    
    @objc private func tapButton() {
        delegate?.trackerRecord(tracker: tracker)
    }
}
