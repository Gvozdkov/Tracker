import UIKit

final class StatisticViewController: UIViewController {
    
    private lazy var headingLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.text = "Cтатистика"
        headingLabel.font = .bold34
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        return headingLabel
    }()
    
    private lazy var errorImageView: UIImageView = {
        let errorImageView = UIImageView(image: UIImage(named: "Error"))
        errorImageView.translatesAutoresizingMaskIntoConstraints = false
        errorImageView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        return errorImageView
    }()
    
    private lazy var questionLabel: UILabel = {
        questionLabel = UILabel()
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.text = "Анализировать пока нечего"
        questionLabel.font = .medium12
        questionLabel.textAlignment = .center
        return questionLabel
    }()
    
    private lazy var screensaver: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsViewController()
    }
    
    private func settingsViewController() {
        view.backgroundColor = .white

        view.addSubview(headingLabel)
        view.addSubview(screensaver)
        
        screensaver.addArrangedSubview(errorImageView)
        screensaver.addArrangedSubview(questionLabel)
        
        NSLayoutConstraint.activate([
        headingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
        headingLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        
        screensaver.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        screensaver.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
        
}

