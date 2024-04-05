import UIKit

final class UnregulatedEventViewController: UIViewController {
    weak var delegate: NewHabitDelegate?
    
    private let categoryViewController = CategoryViewController(viewModel: CategoryViewModel(model: CategoryModel()))
    
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let colors = [
        #colorLiteral(red: 0.9919999838, green: 0.2980000079, blue: 0.2860000134, alpha: 1), #colorLiteral(red: 1, green: 0.5329999924, blue: 0.1180000007, alpha: 1), #colorLiteral(red: 0, green: 0.4819999933, blue: 0.9800000191, alpha: 1), #colorLiteral(red: 0.4309999943, green: 0.2669999897, blue: 0.9959999919, alpha: 1), #colorLiteral(red: 0.200000003, green: 0.8119999766, blue: 0.4120000005, alpha: 1), #colorLiteral(red: 0.90200001, green: 0.4269999862, blue: 0.8309999704, alpha: 1),
        #colorLiteral(red: 0.976000011, green: 0.8309999704, blue: 0.8309999704, alpha: 1), #colorLiteral(red: 0.2039999962, green: 0.6549999714, blue: 0.9959999919, alpha: 1), #colorLiteral(red: 0.275000006, green: 0.90200001, blue: 0.6159999967, alpha: 1), #colorLiteral(red: 0.2080000043, green: 0.2039999962, blue: 0.4860000014, alpha: 1), #colorLiteral(red: 1, green: 0.4040000141, blue: 0.3019999862, alpha: 1), #colorLiteral(red: 1, green: 0.6000000238, blue: 0.8000000119, alpha: 1),
        #colorLiteral(red: 0.9649999738, green: 0.7689999938, blue: 0.5450000167, alpha: 1), #colorLiteral(red: 0.474999994, green: 0.5799999833, blue: 0.9610000253, alpha: 1), #colorLiteral(red: 0.5139999986, green: 0.172999993, blue: 0.9449999928, alpha: 1), #colorLiteral(red: 0.6779999733, green: 0.3370000124, blue: 0.8550000191, alpha: 1), #colorLiteral(red: 0.5529999733, green: 0.4469999969, blue: 0.90200001, alpha: 1), #colorLiteral(red: 0.1840000004, green: 0.8159999847, blue: 0.3449999988, alpha: 1)
    ]
    
    private var subCategory = ""
    
    private var name: String = "" {
        didSet {
            fillingInTheTracker()
        }
    }
    
    private var emoji: String = "" {
        didSet {
            fillingInTheTracker()
        }
    }
    
    private var color: UIColor = .clear {
        didSet {
            fillingInTheTracker()
        }
    }
    
    private lazy var headingLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.font = .medium16
        headingLabel.text = LocalizableKeys.newHabitVCHeadingLabel
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        return headingLabel
    }()
    
    private lazy var nameTrackerTextField: UITextField = {
        let textField = UITextField()
        textField.font = .regular17
        textField.textColor = .gray
        textField.text = LocalizableKeys.enterAName
        textField.backgroundColor = ColorsForTheTheme.shared.table
        textField.layer.cornerRadius = 16
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        textField.addTarget(self, action: #selector(editingDidBeginTextField(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEndTextField(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    private lazy var buttonTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = ColorsForTheTheme.shared.table
        tableView.separatorColor = ColorsForTheTheme.shared.separator
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: tableView.bounds.height / 2, left: 15, bottom: tableView.bounds.height / 2, right: 15)
        tableView.register(ButtonFirstCell.self, forCellReuseIdentifier: "ButtonFirstCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var emojiLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.font = .bold19
        headingLabel.text = "Emoji"
        return headingLabel
    }()
    
    private lazy var emojisCollection: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.register(EmojiCustomCell.self, forCellWithReuseIdentifier: "EmojiCustomCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var colorLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.font = .bold19
        headingLabel.text = LocalizableKeys.newHabitVCColorLabel
        return headingLabel
    }()
    
    private lazy var colorsCollection: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.register(ColorCustomCell.self, forCellWithReuseIdentifier: "ColorCustomCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var cancelButton: UIButton = {
        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        let attributedString = NSAttributedString(
            string: LocalizableKeys.newHabitVCCancelButton,
            attributes: [NSAttributedString.Key.font: font]
        )
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = nil
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = 16
        button.titleLabel?.textColor = .red
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(tapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        let attributedString = NSAttributedString(string: LocalizableKeys.newHabitVCCreateButton, attributes: [NSAttributedString.Key.font: font])
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray
        button.layer.cornerRadius = 16
        button.titleLabel?.textColor = .white
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(tapCreateButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackButton: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        assertionFailure("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsViewController()
        categoryViewController.delegate = self
    }
    
    private func settingsViewController() {
        view.backgroundColor = ColorsForTheTheme.shared.viewController
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(headingLabel)
        scrollView.addSubview(nameTrackerTextField)
        scrollView.addSubview(buttonTableView)
        scrollView.addSubview(emojiLabel)
        scrollView.addSubview(emojisCollection)
        scrollView.addSubview(colorLabel)
        scrollView.addSubview(colorsCollection)
        scrollView.addSubview(stackButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: colorsCollection.bottomAnchor, constant: 100),
            
            headingLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 28),
            headingLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            nameTrackerTextField.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 52),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            
            buttonTableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 24),
            buttonTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonTableView.heightAnchor.constraint(equalToConstant: 75),
            
            emojiLabel.topAnchor.constraint(equalTo: buttonTableView.bottomAnchor, constant: 32),
            emojiLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 28),
            
            emojisCollection.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 25),
            emojisCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            emojisCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            emojisCollection.heightAnchor.constraint(equalToConstant: 200),
            
            colorLabel.topAnchor.constraint(equalTo: emojisCollection.bottomAnchor, constant: 16),
            colorLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 28),
            
            colorsCollection.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 25),
            colorsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            colorsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            colorsCollection.heightAnchor.constraint(equalToConstant: 200),
            
            stackButton.topAnchor.constraint(equalTo: colorsCollection.bottomAnchor, constant: 16),
            stackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            stackButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            stackButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func fillingInTheTracker() {
        if name != "" && subCategory != "" && emoji != "" && color != .clear {
            createButton.backgroundColor = ColorsForTheTheme.shared.buttonAction
            createButton.setTitleColor(ColorsForTheTheme.shared.ButtonText, for: .normal)
            createButton.isEnabled = true
        } else {
            createButton.isEnabled = false
        }
    }
    
    @objc private func editingDidBeginTextField(_ textField: UITextField) {
        if textField.text == LocalizableKeys.enterAName {
            textField.text = ""
            textField.textColor = ColorsForTheTheme.shared.textFieldText
        }
    }
    
    @objc private func editingDidEndTextField(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            textField.text = LocalizableKeys.enterAName
            textField.textColor = .gray
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        name = textField.text ?? ""
        if name == "" {
            createButton.backgroundColor = .gray
        }
    }
    
    @objc private func tapCreateButton() {
        delegate?.newTracker(title: subCategory,
                             name: name,
                             emoji: emoji,
                             color: color,
                             weekday: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday],
                             indexEmoji: IndexPath(),
                             indexColor: IndexPath())
    }
    
    @objc private func tapCancelButton() {
        dismiss(animated: true)
    }
}

// MARK: - extension UITextFieldDelegate
extension UnregulatedEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTrackerTextField {
            let currentText = textField.text ?? ""
            
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return newText.count <= 38
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - extension UITableViewDataSource
extension UnregulatedEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonFirstCell", for: indexPath) as? ButtonFirstCell {
            cell.backgroundColor = .clear
            cell.cellSettings(subCategory: subCategory)
            return cell
        } else {
            assertionFailure("Error - ButtonFirstCell")
            return UITableViewCell()
        }
    }
}

// MARK: - extension UITableViewDelegate
extension UnregulatedEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(categoryViewController, animated: true, completion: nil)
    }
}

// MARK: - extetion UIImage
private extension UIImage {
    convenience init(color: UIColor, size: CGSize = CGSize(width: 40, height: 40), cornerRadius: CGFloat = 8) {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        color.setFill()
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else {
            fatalError("Failed to create image from context")
        }
        self.init(cgImage: cgImage)
    }
}

// MARK: - extetion UICollectionViewDataSource
extension UnregulatedEventViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojisCollection {
            return emojis.count
        } else if collectionView == colorsCollection {
            return colors.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojisCollection {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCustomCell", for: indexPath) as? EmojiCustomCell {
                cell.cellSettings(emojiLabel: emojis[indexPath.item])
                return cell
            }
        } else if collectionView == colorsCollection {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCustomCell", for: indexPath) as? ColorCustomCell {
                let color = colors[indexPath.item] // Получаем цвет из массива
                let image = UIImage(color: color) // Создаем из него UIImage (для этого вам может потребоваться расширение UIImage)
                cell.cellSettings(colorsImage: image)
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

// MARK: - extetion UICollectionViewDelegate
extension UnregulatedEventViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojisCollection {
            let selectedEmogi = emojis[indexPath.item]
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.backgroundColor = .lightGray
                cell.layer.cornerRadius = 16
            }
            emoji = selectedEmogi
            print(emoji)
        } else if collectionView == colorsCollection {
            let selectedColor = colors[indexPath.item]
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.layer.cornerRadius = 8
                cell.layer.borderWidth = 3
                cell.layer.borderColor = selectedColor.withAlphaComponent(0.3).cgColor
            }
            color = selectedColor
            print(color)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // Отменяем выделение и сбрасываем цвет фона для ячейки
        if collectionView == emojisCollection {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.backgroundColor = nil
            }
        }
        if collectionView == colorsCollection {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.backgroundColor = nil
                cell.layer.borderWidth = 0
                cell.layer.borderWidth = 0
            }
        }
    }
}

// MARK: - extetion UICollectionViewDelegateFlowLayout
extension UnregulatedEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == emojisCollection {
            let size = ((UIScreen.main.bounds.width - 16) / CGFloat(8)).rounded(.down)
            return CGSize(width: size, height: size)
        }
        if collectionView == colorsCollection {
            let size = ((UIScreen.main.bounds.width - 16) / CGFloat(8)).rounded(.down)
            return CGSize(width: size, height: size)
        }
        return CGSize()
    }
}

extension UnregulatedEventViewController: SubCategoryProtocol {
    func selectedCategory(category: String?) {
        if let category = category {
            subCategory = category
        }
        buttonTableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}
