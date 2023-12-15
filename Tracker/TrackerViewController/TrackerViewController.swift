import UIKit

class TrackerViewController: UIViewController {
    let newTrackerViewController = NewTrackerViewController()
    private var data = [(header: String, [Tracker])]()
    private var filteredDays = [(header: String, [Tracker])]()
    
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
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var trackerCollection: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.register(TrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSupplementaryView.hederId)
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
        didChangedDatePicker()
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
            trackerCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            screensaver.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            screensaver.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func filteredDaysIsEmpty() {
        if filteredDays.isEmpty {
            screensaver.isHidden = false
        } else {
            screensaver.isHidden = true
        }
    }
    
    private func localizedWeekday(from weekday: Int) -> String {
        switch weekday {
        case 1: return "Воскресенье"
        case 2: return "Понедельник"
        case 3: return "Вторник"
        case 4: return "Среда"
        case 5: return "Четверг"
        case 6: return "Пятница"
        case 7: return "Суббота"
        default: return ""
        }
    }
    
    private func filteredSelectedDay() {
        // Получение выбранной даты из datePicker
        let selectedDate = datePicker.date
        
        // Получение текущего календаря
        let calendar = Calendar.current
        
        // Получение дня недели для выбранной даты
        let selectedWeekday = calendar.component(.weekday, from: selectedDate)
        
        // Получение локализованной строки для выбранного дня недели
        let localizedWeekdayString = localizedWeekday(from: selectedWeekday)
        
        // Создание пустого массива кортежей (String, [Tracker])
        var updatedFilteredDays = [(String, [Tracker])]()
        
        // Итерация через все элементы в data, где каждый элемент представляет собой категорию и список трекеров
        for (category, trackers) in data {
            // Переменная для хранения индекса существующей секции
            var existingSectionIndex: Int?
            
            // Поиск существующей секции для текущей категории в массиве updatedFilteredDays
            for (index, filteredSection) in updatedFilteredDays.enumerated() {
                if filteredSection.0 == category {
                    existingSectionIndex = index
                    break
                }
            }
            
            // Фильтрация трекеров в текущей категории на основе выбранного дня недели
            let filteredTrackers = trackers.filter { tracker in
                if let schedule = tracker.schedule {
                    return schedule.contains(where: { $0.rawValue == localizedWeekdayString })
                }
                return false
            }
            
            // Проверка, что отфильтрованный список трекеров не пустой
            if !filteredTrackers.isEmpty {
                // Если существует секция для данной категории, добавляем отфильтрованные трекеры в эту секцию
                if let existingIndex = existingSectionIndex {
                    updatedFilteredDays[existingIndex].1 += filteredTrackers
                } else {
                    // В противном случае, создаем новую секцию с соответствующей категорией и отфильтрованными трекерами
                    updatedFilteredDays.append((category, filteredTrackers))
                }
            }
        }
        // Обновление массива filteredDays данными из updatedFilteredDays
        filteredDays = updatedFilteredDays
        filteredDaysIsEmpty()
        trackerCollection.reloadData()
    }

    @objc func didChangedDatePicker() {
        filteredSelectedDay()
    }
    
    @objc private func tapButtonNewTracker() {
        self.present(newTrackerViewController, animated: true)
    }
}
// MARK: - extension UISearchBarDelegate
extension TrackerViewController: UISearchBarDelegate {
    // Метод для обработки изменений в тексте searchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // Если строка поиска пуста, отображаем все данные для выбранного дня
            filteredSelectedDay()
        } else {
            // Фильтруем данные на основе введенного запроса
            let filteredData = data.compactMap { (header, trackers) in
                let filteredTrackers = trackers.filter { tracker in
                    // Здесь можно указать условие для фильтрации по вашим критериям
                    let nameMatch = tracker.name.lowercased().contains(searchText.lowercased())
                    let headerMatch = header.lowercased().contains(searchText.lowercased())
                    return nameMatch || headerMatch
                }
                if !filteredTrackers.isEmpty {
                    return (header, filteredTrackers)
                } else {
                    return nil
                }
            }
            filteredDays = filteredData
            filteredDaysIsEmpty()
            trackerCollection.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - extension UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filteredDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredDays[section].1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Проверяем, что в массиве есть данные и индекс находится в пределах допустимых значений
        guard filteredDays.indices.contains(indexPath.section) && filteredDays[indexPath.section].1.indices.contains(indexPath.item) else {
            // Если массив пуст или индекс выходит за пределы массива, возвращаем пустую ячейку
            return UICollectionViewCell()
        }
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCastomCell", for: indexPath) as? TrackerCastomCell {
            let tracker = filteredDays[indexPath.section].1[indexPath.item]
            cell.updateData(title: tracker.name,
                            schedule: tracker.schedule,
                            color: tracker.color,
                            emoji: tracker.emoji,
                            label: tracker.name)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension TrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerSupplementaryView.hederId, for: indexPath) as? TrackerSupplementaryView {
                headerView.titleLabel.text = filteredDays[indexPath.section].header
                return headerView
            }
        }
        return UICollectionReusableView()
    }
}
// MARK: - extension UICollectionViewDelegate
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    // Реализация метода для указания размеров заголовка
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // Указываем размеры заголовка
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2 - 7, height: collectionView.bounds.height / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
}

// MARK: - extension NewHabitDelegate
extension TrackerViewController: NewHabitDelegate {
    func newTracker(title: String, name: String, emoji: String, color: UIColor, weekday: [Weekday]?) {
        let newTracker = Tracker(
            id: UUID(),
            name: name,
            emoji: emoji,
            color: color,
            schedule: weekday
        )
        
        if let existingCategoryIndex = filteredDays.firstIndex(where: { $0.header == title }) {
            data[existingCategoryIndex].1.append(newTracker)
        } else {
            let newCategory = (header: title, [newTracker])
            data.append(newCategory)
        }
        
        didChangedDatePicker()
        trackerCollection.reloadData()
        dismiss(animated: true)
    }
}
