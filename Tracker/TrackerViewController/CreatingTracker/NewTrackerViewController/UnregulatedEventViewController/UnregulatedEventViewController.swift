import UIKit

final class UnregulatedEventViewController: UIViewController {
    
    lazy private var headingLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.font = .medium16
        headingLabel.text = "Новое нерегулярное событие"
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        return headingLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsViewController()
        
    }
    
    private func settingsViewController() {
        view.backgroundColor = .white
        
        view.addSubview(headingLabel)
        
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            ])
    }
}
