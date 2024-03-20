import UIKit

final class NewTrackerViewController: UIViewController {
    let newHabitViewController = NewHabitViewController()
    
    weak var delegate: NewHabitDelegate?
    
    private lazy var headingLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.font = .medium16
        headingLabel.text = LocalizableKeys.newTrackerVCHeadingLabel
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        return headingLabel
    }()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorsForTheTheme.shared.buttonAction
        button.setTitleColor(ColorsForTheTheme.shared.ButtonText, for: .normal)
        button.layer.cornerRadius = 16
        button.setTitle(LocalizableKeys.newTrackerVCHabitButton, for: .normal)
        button.titleLabel?.font = .medium16
        button.addTarget(self, action: #selector(newHabitButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var unregulatedEventButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorsForTheTheme.shared.buttonAction
        button.setTitleColor(ColorsForTheTheme.shared.ButtonText, for: .normal)
        button.layer.cornerRadius = 16
        button.setTitle(LocalizableKeys.newTrackerVCUnregulatedEventButton, for: .normal)
        button.titleLabel?.font = .medium16
        button.addTarget(self, action: #selector(unregulatedEvenButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [habitButton, unregulatedEventButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newHabitViewController.delegate = self.delegate
        settingsViewController()
    }
    
    private func settingsViewController() {
        view.backgroundColor = ColorsForTheTheme.shared.viewController
        view.addSubview(headingLabel)
        view.addSubview(buttonStack)

        
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            buttonStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStack.heightAnchor.constraint(equalToConstant: 136),

            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            unregulatedEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            unregulatedEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            unregulatedEventButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @IBAction private func newHabitButtonAction() {
        let newHabitViewController = NewHabitViewController() // Создание нового экземпляра
        newHabitViewController.delegate = self.delegate // Установка делегата
        self.present(newHabitViewController, animated: true)
    }
    
    @IBAction private func unregulatedEvenButtonAction() {
        let unregulatedEventViewController = UnregulatedEventViewController()
        unregulatedEventViewController.delegate = self.delegate
        self.present(unregulatedEventViewController, animated: true)
    }
}


