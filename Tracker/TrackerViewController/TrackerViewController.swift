import UIKit

class TrackerViewController: UIViewController {
    let newTrackerViewController = NewTrackerViewController()
    
    private var categories: [TrackerCategory] = []
    
    private var saveDate: [SaveDate] = []
    private var selectedDate: Date?
    
    private var titleCell = ""
    private var tracker: Tracker = Tracker(
        id: UUID(),
        name: "",
        emoji: "",
        color: UIColor(),
        schedule: nil
    )
    
    
    private lazy var buttonNewTracker: UIButton = {
        let imageButton = UIImage(systemName: "plus")
        var buttonNewTracker = UIButton(type: .system)
        buttonNewTracker.translatesAutoresizingMaskIntoConstraints = false
        buttonNewTracker.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
        buttonNewTracker.setImage(imageButton, for: .normal)
        buttonNewTracker.addTarget(self, action: #selector(tapButtonNewTracker), for: .touchUpInside)
        buttonNewTracker.tintColor = .black
        return buttonNewTracker
    }()
    
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.backgroundColor = .white
        datePicker.tintColor = .blue
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(didChangedDatePicker), for: .valueChanged)
        return datePicker
    }()
    
    
    //    private lazy var dateFormatter: DateFormatter = {
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.locale = Locale(identifier: "ru_RU")
    //        dateFormatter.dateFormat = "dd.MM.yy"
    //        return dateFormatter
    //    }()
    
    private lazy var headingLabel: UILabel = {
        let labelHeading = UILabel()
        labelHeading.translatesAutoresizingMaskIntoConstraints = false
        labelHeading.text = "Трекеры"
        labelHeading.font = .bold34
        return labelHeading
    }()
    
    private lazy var searchBar: UISearchBar = {
        let text = "Поиск"
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        searchBar.isTranslucent = false
        searchBar.placeholder = text
        searchBar.frame = CGRect(x: 0, y: 0, width: 343, height: 36)
        searchBar.backgroundColor = UIColor.textFieldSearch
        return searchBar
    }()
    
    //    private lazy var headerView: UICollectionReusableView = {
    //       let view = UICollectionReusableView()
    //        view.translatesAutoresizingMaskIntoConstraints = false
    //        view.frame = CGRect(x: 0, y: 0, width: 137, height: 18)
    //        return view
    //    }()
    
    private lazy var trackerCollection: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .clear
        //        collectionView.register(TrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TrackerSupplementaryView")
        collectionView.register(TrackerCastomCell.self, forCellWithReuseIdentifier: "TrackerCastomCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var starImageView: UIImageView = {
        let starImageView = UIImageView(image: UIImage(named: "Star"))
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        return starImageView
    }()
    
    private lazy var questionLabel: UILabel = {
        questionLabel = UILabel()
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.text = "Что будем отслеживать?"
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
    
    //MARK: - UITabBar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newTrackerViewController.delegate = self
        self.restorationIdentifier = "TrackerViewController"
        didChangedDatePicker(datePicker)
        
        categoriesIsEmpty()
        settingsViewController()
    }
    
    private func settingsViewController() {
        view.backgroundColor = .white
        
        view.addSubview(buttonNewTracker)
        view.addSubview(datePicker)
        view.addSubview(trackerCollection)
        view.addSubview(headingLabel)
        view.addSubview(searchBar)
        view.addSubview(screensaver)
        
        screensaver.addArrangedSubview(starImageView)
        screensaver.addArrangedSubview(questionLabel)
        
        NSLayoutConstraint.activate([
            buttonNewTracker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            buttonNewTracker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            
            headingLabel.topAnchor.constraint(equalTo: buttonNewTracker.bottomAnchor, constant: 12),
            headingLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            searchBar.topAnchor.constraint(equalTo: headingLabel.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            trackerCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            trackerCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerCollection.heightAnchor.constraint(equalToConstant: 650),
            
            screensaver.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            screensaver.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func categoriesIsEmpty() {
        if !categories.isEmpty { screensaver.isHidden = false }
    }
    
    private func sortAndReloadCollectionView() {
        if let selectedDate = selectedDate {
            // Сортируйте массив saveDate на основе выбранной даты
            let sortedSaveDate = saveDate.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
            // Обновите источник данных коллекции с отсортированными данными
            // Например, обновите массив saveDate с отсортированными данными и затем вызовите trackerCollection.reloadData()
            //             saveDate = sortedSaveDate
            trackerCollection.reloadData()
        } else {
            let currentDate = Date()
            trackerCollection.reloadData()
        }
    }
    
    @objc private func didChangedDatePicker(_ sender: UIDatePicker) {
        selectedDate = sender.date
        // Вызовите метод для сортировки и перезагрузки коллекции на основе выбранной даты
        sortAndReloadCollectionView()
    }
    
    @objc private func tapButtonNewTracker() {
        self.present(newTrackerViewController, animated: true)
    }
}

// MARK: - extension UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //            categories.count
        //            saveDate.count
        if let selectedDate = selectedDate {
            return saveDate.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Проверяем, что в массиве есть данные и индекс находится в пределах допустимых значений
        guard categories.indices.contains(indexPath.row) else {
            // Если массив пуст или индекс выходит за пределы массива, возвращаем пустую ячейку
            return UICollectionViewCell()
        }
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCastomCell", for: indexPath) as? TrackerCastomCell {
            let trackerCategory = categories[indexPath.row]
            cell.updateData(title: trackerCategory.trackers.first?.name ?? "", schedule: trackerCategory.trackers.first?.schedule, color: trackerCategory.trackers.first?.color, emoji: trackerCategory.trackers.first?.emoji, label: trackerCategory.trackers.first?.name ?? "")
            // Здесь можно обновить ячейку с данными
            // Например: cell.data = sortedData[indexPath.row]
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

//extension TrackerViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard categories.indices.contains(indexPath.row) else {
//            return UICollectionReusableView()
//        }
//
//        if let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TrackerSupplementaryView", for: indexPath) as? TrackerSupplementaryView {
//            view.titleLabel.text = "heder"
//            return view
//    }
//    return UICollectionReusableView()
//    }
//}

// MARK: - extension UICollectionViewDelegate
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    //    // Реализация метода для указания размеров заголовка
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //        // Указываем размеры заголовка
    //        return CGSize(width: collectionView.frame.width, height: 50)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2.1, height: collectionView.bounds.height / 4)
    }
}

// MARK: - extension NewHabitDelegate
extension TrackerViewController: NewHabitDelegate {
    func newTracker(title: String, name: String, emoji: String, color: UIColor, weekday: [Weekday]?) {
        questionLabel.text = nil
        starImageView.image = nil
        
        titleCell = title
        tracker = Tracker(
            id: UUID(),
            name: name,
            emoji: emoji,
            color: color,
            schedule: weekday
        )
        
        let category = TrackerCategory(
            name: titleCell,
            trackers: [tracker]
        )
        
        categories.append(category)
        
        let save = SaveDate(date: Date(), tracker: tracker)
        saveDate.append(save)
        
        trackerCollection.reloadData()
        dismiss(animated: true)
    }
}
