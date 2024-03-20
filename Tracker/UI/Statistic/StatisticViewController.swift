import UIKit

final class StatisticViewController: UIViewController {
    var count: Int {
        get {
            return UserDefaults.standard.integer(forKey: "savedCount")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "savedCount")
        }
    }
    
    private lazy var headingLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.text = LocalizableKeys.statistics
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
        questionLabel.text = LocalizableKeys.statisticVCQuestionLabel
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
    
    private lazy var trackersCompletedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorsForTheTheme.shared.viewController
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var countTrackersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.text = "\(count)"
        return label
    }()
    
    private lazy var trackersCompletedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "Трекеров завершено"
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [countTrackersLabel, trackersCompletedLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.gradientRed.cgColor,
            UIColor.gradientGreen.cgColor,
            UIColor.gradientBlue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradientLayer
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradientBorder(to: trackersCompletedView, gradientLayer: gradientLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        countTrackersLabel.text = "\(count)"
        filter()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsViewController()
    }
    
    private func settingsViewController() {
        view.backgroundColor = ColorsForTheTheme.shared.viewController

        view.addSubview(headingLabel)
        view.addSubview(screensaver)
        view.addSubview(trackersCompletedView)
        trackersCompletedView.addSubview(labelsStackView)
        
        screensaver.addArrangedSubview(errorImageView)
        screensaver.addArrangedSubview(questionLabel)
        
        NSLayoutConstraint.activate([
        headingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
        headingLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        
        screensaver.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        screensaver.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        
        trackersCompletedView.topAnchor.constraint(equalTo: headingLabel.topAnchor, constant: 100),
        trackersCompletedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        trackersCompletedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        trackersCompletedView.heightAnchor.constraint(equalToConstant: 90),
        
        
        labelsStackView.leadingAnchor.constraint(equalTo: trackersCompletedView.leadingAnchor, constant: 12),
        labelsStackView.centerYAnchor.constraint(equalTo: trackersCompletedView.centerYAnchor),
        ])
    }

    private func setupGradientBorder(to view: UIView, cornerRadius: CGFloat = 16, borderWidth: CGFloat = 2.0, gradientLayer: CAGradientLayer) {
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: view.bounds, cornerRadius: cornerRadius)
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = borderWidth
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        gradientLayer.mask = shapeLayer
        view.layer.addSublayer(gradientLayer)
    }
    

    private func filter() {
        if count > 0 {
            screensaver.isHidden = true
            labelsStackView.isHidden = false
            gradientLayer.isHidden = false
        } else {
            screensaver.isHidden = false
            labelsStackView.isHidden = true
            gradientLayer.isHidden = true
        }
    }
        
}
