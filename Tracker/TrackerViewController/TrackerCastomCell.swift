import UIKit

final class TrackerCastomCell: UICollectionViewCell {
    private var counter = 0
    private var imageButton = UIImage(systemName: "plus")
    
    private lazy var frameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = .blue
        return view
    }()
    
    private lazy var gradient: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        label.font = .medium16
        label.text = "🙂"
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
        label.textColor = .blackDay
        label.text = "\(counter) дней"
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        constraintsSettingsView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constraintsSettingsView() {
        colorView.addSubview(gradient)
        colorView.addSubview(emojiLabel)
        colorView.addSubview(nameLabel)
        frameView.addSubview(colorView)
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
            
            gradient.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            gradient.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            gradient.widthAnchor.constraint(equalToConstant: 28),
            gradient.heightAnchor.constraint(equalToConstant: 28),
            
            emojiLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 14),
            emojiLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 15.5),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
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
    
    func updateData(title: String, schedule: [Weekday]?, color: UIColor?, emoji: String?, label: String?) {
//        titleCell.text = title
        colorView.backgroundColor = color
        emojiLabel.text = emoji
        nameLabel.text = label
        button.backgroundColor = color
    }
    
    @objc private func tapButton() {
        if button.alpha == 1.0 {
            counter += 1
            dayLabel.text = "\(counter) дней"
            button.alpha = 0.3
            imageButton = UIImage(systemName: "checkmark")
            button.setImage(imageButton, for: .normal)
        } else {
            counter -= 1
            dayLabel.text = "\(counter) дней"
            button.alpha = 1
            imageButton = UIImage(systemName: "plus")
            button.setImage(imageButton, for: .normal)
        }
    }
}
