import UIKit

protocol NewSaveCategoryDelegate: AnyObject {
    func saveCategory(category: String?)
}

final class NewCategoryViewController: UIViewController {
    weak var delegate: NewSaveCategoryDelegate?
    private let startText = "Введите название трекера"
    
    private lazy var headingLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.font = .medium16
        headingLabel.text = "Новая категория"
        return headingLabel
    }()
    
    private lazy var nameTrackerTextField: UITextField = {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .regular17
        textField.textColor = .gray
        textField.text = startText
        textField.backgroundColor = .backgroundDay
        textField.layer.cornerRadius = 16
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.returnKeyType = .continue
        textField.addTarget(self, action: #selector(editingDidBeginTextField(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEndTextField(_:)), for: .editingDidEnd)
        return textField
    }()
    
    private lazy var confirmationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray
        button.layer.cornerRadius = 16
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .medium16
        button.addTarget(self, action: #selector(confirmationButtonAction), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTrackerTextField.delegate = self
        
        settingsViewController()
    }
    
    private func settingsViewController() {
        view.backgroundColor = .white
        
        view.addSubview(headingLabel)
        view.addSubview(nameTrackerTextField)
        view.addSubview(confirmationButton)
        
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTrackerTextField.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 52),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            
            confirmationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            confirmationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmationButton.heightAnchor.constraint(equalToConstant: 60),
            
        ])
    }
    
    @objc private func editingDidBeginTextField(_ textField: UITextField) {
        if textField.text == startText {
            textField.text = ""
            textField.textColor = .black
        }
    }
    
    @objc private func editingDidEndTextField(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            textField.text = startText
            textField.textColor = .gray
        }
    }

    @IBAction private func confirmationButtonAction() {
        let newCategory = nameTrackerTextField.text
        self.delegate?.saveCategory(category: newCategory)
        nameTrackerTextField.textColor = .gray
        nameTrackerTextField.text = startText
    }
}

extension NewCategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTrackerTextField {
            
            let currentText = (textField.text ?? "") as NSString
            let newText = currentText.replacingCharacters(in: range, with: string)
            
            if !newText.isEmpty {
                confirmationButton.backgroundColor = .black
                confirmationButton.isEnabled = true
            } else {
                confirmationButton.isEnabled = false
                confirmationButton.backgroundColor = .gray
            }
            return newText.count <= 38
        }
        return true
    }
}
