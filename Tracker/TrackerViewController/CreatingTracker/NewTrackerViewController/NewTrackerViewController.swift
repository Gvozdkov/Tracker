import UIKit

final class NewTrackerViewController: UIViewController {
    let newHabitViewController = NewHabitViewController()
    let unregulatedEventViewController = UnregulatedEventViewController()
    
    weak var delegate: NewHabitDelegate?
    
    lazy private var headingLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.font = .medium16
        headingLabel.text = "Создание трекера"
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        return headingLabel
    }()
    
    lazy private var habitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = .medium16
        button.addTarget(self, action: #selector(newHabitButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy private var unregulatedEventButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.setTitle("Нерегулируемое событие", for: .normal)
        button.titleLabel?.font = .medium16
        button.addTarget(self, action: #selector(unregulatedEvenButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newHabitViewController.delegate = self.delegate
        settingsViewController()
    }
    
    private func settingsViewController() {
        view.backgroundColor = .white
        view.addSubview(headingLabel)
        view.addSubview(habitButton)
        view.addSubview(unregulatedEventButton)
        
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            habitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 395),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),

            unregulatedEventButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 471),
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
        self.present(unregulatedEventViewController, animated: true)
    }
}

