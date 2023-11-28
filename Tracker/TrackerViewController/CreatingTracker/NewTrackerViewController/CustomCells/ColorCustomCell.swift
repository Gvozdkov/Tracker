import UIKit

final class ColorCustomCell: UICollectionViewCell {
    
    lazy var colorsImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 8
//        image.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        constraintsSettingsView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constraintsSettingsView() {
        contentView.addSubview(colorsImage)
        
        NSLayoutConstraint.activate([
            colorsImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            colorsImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            colorsImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorsImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorsImage.widthAnchor.constraint(equalToConstant: 40),
            colorsImage.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
