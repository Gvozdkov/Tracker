import UIKit

final class EmojiCustomCell: UICollectionViewCell {
    
   private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .bold32
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        constraintsSettingsView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        assertionFailure("init(coder:) has not been implemented")
    }

    private func constraintsSettingsView() {
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func cellSettings(emojiLabel: String?) {
        self.emojiLabel.text = emojiLabel
    }
}
