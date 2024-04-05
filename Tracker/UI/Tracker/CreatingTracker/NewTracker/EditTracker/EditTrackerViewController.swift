import UIKit

protocol EditTracker: AnyObject {
    func editTracker(category: String, tracker: Tracker)
}

final class EditTrackerViewController: UIViewController {
    weak var delegateEdit: EditTracker?
    
    private let categoryViewController = CategoryViewController(viewModel: CategoryViewModel(model: CategoryModel()))
    private let scheduleViewController = ScheduleViewController()
    private let categoryModel = CategoryModel()
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
    
    private var weekday: [Weekday]? {
        didSet {
            fillingInTheTracker()
        }
    }
    
    private var scheduleString: String? {
        guard let schedule = weekday else { return nil } // проверяет выбранны дни недели или нет, если выбраны возвращает дни
        if weekday?.count == Weekday.allCases.count { return LocalizableKeys.newHabitVCEveryday } // если все дни были выбранны выводится надпись "Каждый день"
        let shortForms: [String] = schedule.map { $0.shortForm } //преобразовывает выбраные дни в сокращеный форм
        return shortForms.joined(separator: ", ") // сдесь эелементы массива объединяются в одну строчку разделеными ,
    }
    
    private var subCategory = ""
    
    private var tracker: Tracker?
    private var countDays = ""
//    private var colorAndEmojiIndex: ColorAndEmojiIndex?
    
    private var indexEmoji = IndexPath()
    private var indexColor = IndexPath()
    
    private var emojiIndex: Int?
    private var selectEmoji = ""
    private var colorIndex: Int?
    private var selectColor: UIColor?
    
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
    
    private lazy var headingLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.font = .medium16
        headingLabel.text = "Редактирование привычки"
        return headingLabel
    }()
    
    private lazy var daysLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.font = .bold32
        headingLabel.text = "6 days"
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
    
    lazy var buttonTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = ColorsForTheTheme.shared.table
        tableView.separatorColor = ColorsForTheTheme.shared.separator
        tableView.separatorInset = .init(top: tableView.bounds.height / 2, left: 15, bottom: tableView.bounds.height / 2, right: 15)
        tableView.register(ButtonFirstCell.self, forCellReuseIdentifier: "ButtonFirstCell")
        tableView.register(ButtonSecondCell.self, forCellReuseIdentifier: "ButtonSecondCell")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        editTracker(countDay: countDays, tracker: tracker)
        findMatchingEmojiIndex()
        findMatchingColorIndex()
//        print("colorAndEmojiIndex \(colorAndEmojiIndex)")
//        if let colorIndexPath = colorAndEmojiIndex?.color {
//            let colorIndex = colorIndexPath.item
//            self.colorIndex = colorIndex
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryViewController.delegate = self
        scheduleViewController.delegate = self
        settingsViewController()
        fillingInTheTracker()
    }
    
    private func settingsViewController() {
        view.backgroundColor = ColorsForTheTheme.shared.viewController
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(headingLabel)
        scrollView.addSubview(daysLabel)
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
            
            daysLabel.topAnchor.constraint(equalTo: headingLabel.topAnchor, constant: 40),
            daysLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            nameTrackerTextField.topAnchor.constraint(equalTo: daysLabel.bottomAnchor, constant: 40),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            
            buttonTableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 24),
            buttonTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonTableView.heightAnchor.constraint(equalToConstant: 150),
            
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
        guard let tracker = self.tracker else { return }
        let isSame = tracker.color.isEqualToColor(otherColor: color) && tracker.schedule == weekday && tracker.emoji == emoji && tracker.name == name
        
        if !isSame && name != "" && emoji != "" && weekday != nil && color != .clear {
            createButton.backgroundColor = ColorsForTheTheme.shared.buttonAction
            createButton.setTitleColor(ColorsForTheTheme.shared.ButtonText, for: .normal)
            createButton.isEnabled = true
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .gray
        }
    }

    private func editTracker(countDay: String?, tracker: Tracker?) {
        nameTrackerTextField.text = tracker?.name
        name = tracker?.name ?? ""
        daysLabel.text = countDay
        weekday = tracker?.schedule
        selectEmoji = tracker?.emoji ?? ""
        selectColor = tracker?.color ?? UIColor.clear
        
        findMatchingEmojiIndex()
        findMatchingColorIndex()
        
        buttonTableView.reloadData()
        emojisCollection.reloadData()
        colorsCollection.reloadData()
        
        
        //        if let tracker = tracker {
        //            selectEmoji = tracker.emoji
//            selectColor = tracker.color
//            self.colorAndEmojiIndex = colorAndEmojiIndex
//            print("editTracker colorAndEmojiIndex \(colorAndEmojiIndex) ")
//            findMatchingEmojiIndex()
//            
//            buttonTableView.reloadData()
//            emojisCollection.reloadData()
//            colorsCollection.reloadData()
//        }
    }
    
    private func findMatchingEmojiIndex() {
        if let index = emojis.firstIndex(of: selectEmoji) {
            emojiIndex = index
            emoji = emojis[index]
        } else {
            emojiIndex = nil
        }
    }

    
    private func findMatchingColorIndex() {
        if let selectColor = selectColor {
            if let index = colors.firstIndex(where: { $0.isEqualToColor(otherColor: selectColor) }) {
                colorIndex = index
                color = colors[index]
            } else {
                print("Цвет не найден в массиве")
            }
        }
    }

    func updateTracker(category: String?, countDays: String?, tracker: Tracker?) {
        if let category = category, let countDay = countDays, let tracker = tracker {
            subCategory = category
            self.countDays = countDay
            self.tracker = tracker
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

    
    @objc private func tapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func tapCreateButton() {
        if let id = tracker?.id as? UUID {
            let trackerUpdate = Tracker(id: id, name: name, emoji: emoji, color: color, schedule: weekday, isPin: false)
            delegateEdit?.editTracker(category: subCategory, tracker: trackerUpdate)
        }
    }
}


// MARK: - extension UITextFieldDelegate
extension EditTrackerViewController: UITextFieldDelegate {
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
extension EditTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonFirstCell", for: indexPath) as? ButtonFirstCell {
                cell.backgroundColor = .clear
                cell.cellSettings(subCategory: subCategory)
                return cell
            } else {
                assertionFailure("Error - ButtonFirstCell")
            }
        } else if indexPath.item == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonSecondCell", for: indexPath) as? ButtonSecondCell {
                cell.backgroundColor = .clear
                cell.cellSettings(subSchedule: scheduleString)
                return cell
            } else {
                assertionFailure("Error - ButtonSecondCell")
            }
        }
        return UITableViewCell()
    }
}

// MARK: - extension UITableViewDelegate
extension EditTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            present(categoryViewController, animated: true)
            categoryViewController.selectedCategoty = subCategory
            categoryModel.selectCategory = subCategory
            
        } else {
            scheduleViewController.selectedDay(weekday: weekday ?? [])
            present(scheduleViewController, animated: true)
        }
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
extension EditTrackerViewController: UICollectionViewDataSource {
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
                   cell.backgroundColor = .clear
                   

                   if indexPath.row == emojiIndex { // Проверка на совпадение с matchingIndex
                       cell.backgroundColor = .lightGray
                       cell.layer.cornerRadius = 16
                   }
               
                   cell.cellSettings(emojiLabel: emojis[indexPath.item])
                   return cell
               }
           } else if collectionView == colorsCollection {
               if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCustomCell", for: indexPath) as? ColorCustomCell {
                   let color = colors[indexPath.item] // Получаем цвет из массива
                   let image = UIImage(color: color)
   
                   cell.layer.cornerRadius = 0
                   cell.layer.borderWidth = 0
                   cell.layer.borderColor = nil
                   
                   if indexPath.row == colorIndex { // Проверка на совпадение с matchingIndex
                       let selectedColor = colors[indexPath.item]
                       cell.layer.cornerRadius = 8
                       cell.layer.borderWidth = 3
                       cell.layer.borderColor = selectedColor.withAlphaComponent(0.3).cgColor
                   }
                   cell.cellSettings(colorsImage: image)
                   return cell
               }
           }
           return UICollectionViewCell()
    }
}


// MARK: - extetion UICollectionViewDelegate
extension EditTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojisCollection {
            let selectedEmogi = emojis[indexPath.item]
            
            // Сброс предыдущего выбранного элемента
            if let previousIndex = emojiIndex {
                if let previousCell = collectionView.cellForItem(at: IndexPath(item: previousIndex, section: 0)) {
                    previousCell.backgroundColor = nil
                    previousCell.layer.cornerRadius = 0
                }
            }

            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.backgroundColor = .lightGray
                cell.layer.cornerRadius = 16
            }
            emoji = selectedEmogi
            print(emoji)
            indexEmoji = indexPath
            print("indexEmoji - \(indexEmoji)")
        }  else if collectionView == colorsCollection {
            let selectedColor = colors[indexPath.item]
            
            // Сброс предыдущего выбранного элемента
            if let previousIndex = colorIndex {
                if let previousCell = collectionView.cellForItem(at: IndexPath(item: previousIndex, section: 0)) {
                    previousCell.layer.cornerRadius = 0
                    previousCell.layer.borderWidth = 0
                    previousCell.layer.borderColor = nil
                }
            }

            if let cell = collectionView.cellForItem(at: indexPath) {
                colorIndex = nil
                cell.layer.cornerRadius = 8
                cell.layer.borderWidth = 3
                cell.layer.borderColor = selectedColor.withAlphaComponent(0.3).cgColor
            }
            
            color = selectedColor
            colorIndex = indexPath.item
            print(color)
            
            indexColor = indexPath
            print("indexColor - \(indexColor)")
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
extension EditTrackerViewController: UICollectionViewDelegateFlowLayout {
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

extension EditTrackerViewController: SubCategoryProtocol {
    func selectedCategory(category: String?) {
        if let category = category {
            subCategory = category
        }
        buttonTableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

extension EditTrackerViewController: ScheduleViewControllerDelegate {
    func didConfirm(_ schedule: [Weekday]) {
        weekday = schedule
        buttonTableView.reloadData()
        dismiss(animated: true)
    }
}


private extension UIColor {
    func isEqualToColor(otherColor : UIColor) -> Bool {
      var red:CGFloat = 0
      var green:CGFloat  = 0
      var blue:CGFloat = 0
      var alpha:CGFloat  = 0
      self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

      var red2:CGFloat = 0
      var green2:CGFloat  = 0
      var blue2:CGFloat = 0
      var alpha2:CGFloat  = 0
      otherColor.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)

      let distance = sqrt(pow((red - red2), 2) + pow((green - green2), 2) + pow((blue - blue2), 2) )
      if distance <= 0.003 {
        return true
      } else {
        return false
      }
    }
}
