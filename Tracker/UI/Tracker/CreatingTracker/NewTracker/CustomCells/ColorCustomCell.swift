import UIKit

final class ColorCustomCell: UICollectionViewCell {
    
   private lazy var colorsImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 8
        image.contentMode = .scaleAspectFit
        return image
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
        contentView.addSubview(colorsImage)
        
        NSLayoutConstraint.activate([
            colorsImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            colorsImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            colorsImage.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            colorsImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            colorsImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorsImage.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func cellSettings(colorsImage: UIImage?) {
        self.colorsImage.image = colorsImage
    }
}
