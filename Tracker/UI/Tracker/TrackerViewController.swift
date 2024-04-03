import UIKit

class TrackerViewController: UIViewController {
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    private let newTrackerViewController = NewTrackerViewController()
    private let trackerCastomCell = TrackerCastomCell()
    private let filtersViewController = FiltersViewController()
    private let statisticViewController = StatisticViewController()
    private let editTrackerViewController = EditTrackerViewController()
    
    private var allData = [(header: String, [Tracker])]()
    private var data = [(header: String, [Tracker])]()
    private var pinData = (header: "Закрепленые", [Tracker]())
    private var filteredDays = [(header: String, [Tracker])]()
    private var trackerRecords = [TrackerRecord]()
    
    private var currentDate = Date()
    private var currentFilter = LocalizableKeys.allTrackers
    private var updateCategory = "ghh"
    private var updateCountDay = "9"
    private var uppdateTracker: Tracker?
    private var indexEmoji = IndexPath()
    private var indexColor = IndexPath()
    
    private lazy var buttonNewTracker: UIButton = {
        let imageButton = UIImage(systemName: "plus")?.withTintColor(ColorsForTheTheme.shared.buttonAction, renderingMode: .alwaysOriginal)
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
        datePicker.setValue(ColorsForTheTheme.shared.ButtonText, forKey: "textColor")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.layer.masksToBounds = true
        datePicker.layer.cornerRadius = 8
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(didChangedDatePicker), for: .valueChanged)
        datePicker.backgroundColor = ColorsForTheTheme.shared.datePicker
        return datePicker
    }()
    
    private lazy var headingLabel: UILabel = {
        let labelHeading = UILabel()
        labelHeading.translatesAutoresizingMaskIntoConstraints = false
        labelHeading.text = LocalizableKeys.trackersText
        labelHeading.font = .bold34
        return labelHeading
    }()
    
    private lazy var searchBar: UISearchBar = {
        let text = LocalizableKeys.trackerVCSearchBar
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        searchBar.isTranslucent = false
        searchBar.placeholder = text
        searchBar.barTintColor = ColorsForTheTheme.shared.viewController
        searchBar.backgroundColor = ColorsForTheTheme.shared.searchBar
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
        questionLabel.text = LocalizableKeys.trackerVCQuestionLabelFirst
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
    
    private let filtersButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalizableKeys.filters, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(tapfiltersButton), for: .touchUpInside)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsService.openScreenReport(screen: .main)
        do {
            if let fetchedTrackerRecords = try trackerRecordStore.fetchAllTrackerRecordCoreData(trackerRecords) {
                trackerRecords = fetchedTrackerRecords.map { record in
                    return TrackerRecord(trackerId: record.id ?? UUID(), date: record.date ?? Date())
                }
                trackerCollection.reloadData()
            }
        } catch {
            print("Ошибка при извлечении данных trackerRecords: \(error.localizedDescription)")
        }
        filteredDaysIsEmpty()
        
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allData = trackerCategoryStore.fetchAllReturnModel()
        didDataChange()
        if let date = datePicker.date.removeTimeStamp() {
            currentDate = date
        } else {
            print("Error currentDate")
        }
        
        newTrackerViewController.delegate = self
        filtersViewController.delegate = self
        editTrackerViewController.delegateEdit = self
        self.restorationIdentifier = "TrackerViewController"
        
        didChangedDatePicker()
        settingsViewController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsService.closeScreenReport(screen: .main)
    }
    
    private func settingsViewController() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = ColorsForTheTheme.shared.viewController
        
        view.addSubview(buttonNewTracker)
        view.addSubview(datePicker)
        view.addSubview(trackerCollection)
        view.addSubview(headingLabel)
        view.addSubview(searchBar)
        view.addSubview(screensaver)
        view.addSubview(filtersButton)
        
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
            screensaver.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            filtersButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.widthAnchor.constraint(equalToConstant: 114)
        ])
    }
    
    private func filteredDaysIsEmpty() {
        if !data.isEmpty {
            starImageView.image = UIImage(named: "No")
            questionLabel.text = LocalizableKeys.trackerVCQuestionLabelNo
        }
        
        if filteredDays.isEmpty {
            screensaver.isHidden = false
        } else {
            screensaver.isHidden = true
        }
        
        if data.isEmpty {
            filtersButton.isHidden = true
        } else {
            filtersButton.isHidden = false
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
        // Получение текущего календаря
        let calendar = Calendar.current
        
        // Получение дня недели для выбранной даты
        let selectedWeekday = calendar.component(.weekday, from: currentDate)
        
        // Получение локализованной строки для выбранного дня недели
        let localizedWeekdayString = localizedWeekday(from: selectedWeekday)
        
        // Создание пустого массива кортежей (String, [Tracker])
        var updatedFilteredDays = [(String, [Tracker])]()
        if !pinData.1.isEmpty {
            updatedFilteredDays.append(pinData)
        }
        
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
    
    private func filterTrackersForSelectedDay() {
        currentDate = datePicker.date.removeTimeStamp() ?? Date()
        datePicker.date = Date()  // Устанавливаем текущую дату в datePicker
        let selectedDate = currentDate  // Получаем выбранную дату из datePicker
        
        let calendar = Calendar.current
        let selectedWeekday = calendar.component(.weekday, from: selectedDate)
        let localizedWeekdayString = localizedWeekday(from: selectedWeekday)
        
        var updatedFilteredDays = [(String, [Tracker])]()
        
        for (category, trackers) in data {
            let filteredTrackers = trackers.filter { tracker in
                if let schedule = tracker.schedule {
                    if schedule.count == 2 && schedule[0] == .monday && schedule[1] == .monday {
                        return true  // Отображаем каждый день, так как расписание содержит два понедельника
                    } else {
                        return schedule.contains(where: { $0.rawValue == localizedWeekdayString })
                    }
                }
                return false
            }
            
            updatedFilteredDays.append((category, filteredTrackers))  // Добавляем все отфильтрованные трекеры, даже если список пустой
        }
        
        filteredDays = updatedFilteredDays
        filteredDaysIsEmpty()
        trackerCollection.reloadData()
    }
    
    private func showCompletedTrackersForSelectedDay() {
        currentDate = datePicker.date.removeTimeStamp() ?? Date()
        let selectedDate = currentDate  // Получаем выбранную дату из datePicker
        
        var updatedFilteredDays = [(header: String, [Tracker])]()
        
        for (category, trackers) in data {
            let completedTrackers = trackers.filter { tracker in
                // Проверяем, есть ли завершенная запись для данного трекера и выбранной даты
                return trackerRecords.contains(where: { $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: selectedDate) })
            }
            
            if !completedTrackers.isEmpty {
                updatedFilteredDays.append((category, completedTrackers))
            }
        }
        
        filteredDays = updatedFilteredDays
        filteredDaysIsEmpty()
        trackerCollection.reloadData()
    }
    
    private func showUncompletedTrackersForSelectedDay() {
        currentDate = datePicker.date.removeTimeStamp() ?? Date()
        let selectedDate = currentDate  // Получаем выбранную дату из datePicker
        
        var updatedFilteredDays = [(header: String, [Tracker])]()
        
        for (category, trackers) in data {
            let uncompletedTrackers = trackers.filter { tracker in
                let hasCompletedRecord = trackerRecords.contains { $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
                if let schedule = tracker.schedule {
                    let calendar = Calendar.current
                    let selectedWeekday = calendar.component(.weekday, from: selectedDate)
                    let localizedWeekdayString = self.localizedWeekday(from: selectedWeekday)
                    let shouldDisplay = schedule.contains(Weekday(rawValue: localizedWeekdayString) ?? Weekday.monday)
                    return shouldDisplay && !hasCompletedRecord
                } else {
                    return false
                }
            }
            
            if !uncompletedTrackers.isEmpty {
                updatedFilteredDays.append((category, uncompletedTrackers))
            }
        }
        
        filteredDays = updatedFilteredDays
        filteredDaysIsEmpty()
        trackerCollection.reloadData()
    }
    
    private func filterTrackerEvent(_ tracker: Tracker, _ counterDays: Int) -> String {
        let tasksTracker = String.localizedStringWithFormat(
            NSLocalizedString("tasksTracker", comment: "Number of remaining tasks"), counterDays)
        let tasksHabit = String.localizedStringWithFormat(
            NSLocalizedString("tasksHabit", comment: "Number of remaining tasks"), counterDays)
        
        var result = ""
        if let schedule = tracker.schedule {
            if Set(schedule) == Set(Weekday.allCases) {
                result = tasksHabit
                print("tasksHabit")
            } else {
                result = tasksTracker
                print("tasksTracker")
            }
        }
        return result
    }
    
    private func getTotalDateCount(forTrackerId id: UUID) -> Int {
        let matchingRecords = trackerRecords.filter { $0.trackerId == id }
        return matchingRecords.count
    }
    
    private func addNewTracker(title: String, newTracker: Tracker) {
        if let existingCategoryIndex = allData.firstIndex(where: { $0.header == title }) {
            if !allData.contains(where: { $0.1.contains(where: { $0.id == newTracker.id }) }) {
                allData[existingCategoryIndex].1.append(newTracker)
            }
        } else {
            let newCategory = (header: title, [newTracker])
            allData.append(newCategory)
        }
        
        do {
            try trackerStore.addNewTracker(title, newTracker)
            print("Проверка добавления \(newTracker)")
        } catch {
            print("Ошибка добавления трекера: \(error.localizedDescription)")
        }
        didDataChange()
        didChangedDatePicker()
        trackerCollection.reloadData()
    }
    
    private func deleteTracker(tracker: Tracker) {
        guard let currenCategoryIndex = allData.firstIndex(where: { $0.1.contains { track in
            track.id == tracker.id }})  else { return }
        var currentData = allData[currenCategoryIndex]
        currentData.1 = currentData.1.filter { $0.id != tracker.id }
        allData[currenCategoryIndex] = currentData
        didDataChange()
        didChangedDatePicker()
        
    }
    
    private func updateTrackerData(category: String, tracker: Tracker) {
        if let currenCategoryIndex = allData.firstIndex(where: { $0.1.contains { track in
            track.id == tracker.id }})  {
            var currentData = allData[currenCategoryIndex]
            currentData.1 = currentData.1.filter { $0.id != tracker.id }
            currentData.1.append(tracker)
            allData[currenCategoryIndex] = currentData
        } else {
            let newCategory = (category, [tracker])
            allData.append(newCategory)
        }
        
        didDataChange()
        didChangedDatePicker()
    }
    
    private func didDataChange() {
        data = allData.map { category in
            let trackers = category.1.filter { !$0.isPin }
            return (category.header, trackers)
        }
        let tempTrackers = allData.flatMap { category in
            let trackers = category.1.filter { $0.isPin }
            return  trackers
        }
        pinData.1 = tempTrackers
    }
    
    @objc private func didChangedDatePicker() {
        currentDate = datePicker.date.removeTimeStamp() ?? Date()
        
        switch currentFilter {
        case LocalizableKeys.allTrackers:
            filteredSelectedDay()
        case LocalizableKeys.trackersForToday:
            currentDate = Calendar.current.startOfDay(for: Date())
            datePicker.setDate(currentDate, animated: true)
            filteredSelectedDay()
        case LocalizableKeys.completed:
            showCompletedTrackersForSelectedDay()
        case LocalizableKeys.notCompleted:
            showUncompletedTrackersForSelectedDay()
        default:
            break
        }
    }
    
    @objc private func tapButtonNewTracker() {
        AnalyticsService.addTrackReport()
        self.present(newTrackerViewController, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc private func tapfiltersButton() {
        AnalyticsService.addFilterReport()
        self.present(filtersViewController, animated: true)
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
                    filteredDaysIsEmpty()
                    return (header, filteredTrackers)
                } else {
                    filteredDaysIsEmpty()
                    return nil
                }
            }

            filteredDays = filteredData
            trackerCollection.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        let targetView = configurationTargetView(indexPath: indexPath)
        return UITargetedPreview(view: targetView.0, parameters: targetView.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, dismissalPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        let targetView = configurationTargetView(indexPath: indexPath)
        return UITargetedPreview(view: targetView.0, parameters: targetView.1)
    }
    
    private func configurationTargetView(indexPath: IndexPath) -> (UIView, UIPreviewParameters) {
        guard let cell = trackerCollection.cellForItem(at: indexPath) as? TrackerCastomCell else { return (UIView(), UIPreviewParameters())}
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        let targetView = cell.colorView
        return (targetView, parameters)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCastomCell", for: indexPath) as? TrackerCastomCell else { return nil }
        
        if indexPath.section < filteredDays.count {
            let sectionData = filteredDays[indexPath.section]
            let rowData = sectionData.1
            
            if indexPath.row < rowData.count {
                let header = sectionData.header
                let trackerItem = rowData[indexPath.row]
                
                self.updateCategory = header
                self.uppdateTracker = trackerItem
                if let tracker = uppdateTracker {
                    let countDays = getTotalDateCount(forTrackerId: tracker.id)
                    updateCountDay = "\(countDays)"
                }
                
            }
        }
        
        
        var pinTracker: Bool = uppdateTracker?.isPin ?? false
        
        //        let pinned = pinnedTrackerCell(cell: cell, indexPath: indexPath, date: datePicker.date)
        //        pinTracker = !pinned
        
        let menu = UIMenu(
            children: [
                UIAction(title: pinTracker ? LocalizableKeys.trackerVCUnpin : LocalizableKeys.trackerVCPin) { [weak self] _ in
                    AnalyticsService.clickRecordTrackReport()
                    if !pinTracker {
                        self?.makePin(category: self?.updateCategory, tracker: self?.uppdateTracker)
                    } else {
                        self?.makeUnpin(category: self?.updateCategory, tracker: self?.uppdateTracker)
                    }
                },
                UIAction(title: LocalizableKeys.trackerVCEdit) { [weak self] _ in
                    AnalyticsService.editTrackReport()
                    if let vc = self?.editTrackerViewController {
                        self?.present(vc, animated: true)
                    }
                    self?.editTrackerViewController.updateTracker(category: self?.updateCategory, countDays: self?.updateCountDay, tracker: self?.uppdateTracker)
                },
                UIAction(title: LocalizableKeys.trackerVCDelete, image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .destructive) { _ in
                    AnalyticsService.deleteTrackReport()
                    if let uppdateTracker = self.uppdateTracker {
                        do {
                            try self.trackerStore.deleteTracker(uppdateTracker)
                            self.deleteTracker(tracker: uppdateTracker)
                        } catch {
                            print("Ошибка удаления трекера: \(error.localizedDescription)")
                        }
                    }
                }
            ])
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return menu
        }
        
        return configuration
    }
    
    func makePin(category: String?, tracker: Tracker?) {
        guard let category, let tracker else { return }
        do {
            try trackerStore.updateTracker(newCategory: category, tracker: tracker, isPin: true)
        } catch {
            print("Ошибка обновления trackerStore.updateTracker: \(error.localizedDescription)")
        }
        updateTrackerData(category: category, tracker: Tracker(tracker: tracker, isPinned: true))
    }
    
    func makeUnpin(category: String?, tracker: Tracker?) {
        guard let category, let tracker else { return }
        do {
            try trackerStore.updateTracker(newCategory: category, tracker: tracker, isPin: false)
        } catch {
            print("Ошибка обновления trackerStore.updateTracker: \(error.localizedDescription)")
        }
        updateTrackerData(category: category, tracker: Tracker(tracker: tracker, isPinned: false))
    }
}
// MARK: - extension UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filteredDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section < filteredDays.count else {
            return 0
        }
        return filteredDays[section].1.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        updateCategory = filteredDays[indexPath.section].0
        let tracker = filteredDays[indexPath.section].1[indexPath.item]
        uppdateTracker = tracker
        let counterDays = getTotalDateCount(forTrackerId: tracker.id)
        let eventText = filterTrackerEvent(tracker, counterDays)
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCastomCell", for: indexPath) as? TrackerCastomCell {
            
            if trackerRecords.first(where: { $0.trackerId == tracker.id && $0.date == currentDate}) != nil {
                
                cell.updateData(tracker: tracker, click: true, counterDays: eventText)
                AnalyticsService.clickTrackerReport()
            } else {
                cell.updateData(tracker: tracker, click: false, counterDays: eventText)
                
            }
            cell.delegate = self
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
        let paddingSpace = 9 // отступы слева, между ячейками и справа
        let availableWidth = collectionView.bounds.width - CGFloat(paddingSpace)
        let widthPerItem = availableWidth / 2
        return CGSize(width: widthPerItem, height: collectionView.bounds.height / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
}

// MARK: - extension NewHabitDelegate
extension TrackerViewController: NewHabitDelegate {
    func newTracker(title: String, name: String, emoji: String, color: UIColor, weekday: [Weekday]?, indexEmoji: IndexPath, indexColor: IndexPath) {
        let newTracker = Tracker(id: UUID(),
                                 name: name,
                                 emoji: emoji,
                                 color: color,
                                 schedule: weekday, 
                                 isPin: false)
        addNewTracker(title: title, newTracker: newTracker)
        
        dismiss(animated: true)
    }
}

// MARK: - TrackerCellDelegate
extension TrackerViewController: TrackerCellDelegate {
    func trackerRecord(tracker: Tracker) {
        let record = TrackerRecord(trackerId: tracker.id, date: currentDate)
        
        if let index = trackerRecords.firstIndex(of: record) {
            do {
                trackerRecords.remove(at: index)
                statisticViewController.count -= 1
                try trackerRecordStore.deleteTracker(record.trackerId, record.date)
            } catch {
                print("Ошибка удаления рекорда: \(error.localizedDescription)")
            }
        } else {
            do {
                trackerRecords.append(record)
                statisticViewController.count += 1
                try trackerRecordStore.addNewTrackerRecord(record)
            } catch {
                print("Ошибка добавления рекорда: \(error.localizedDescription)")
            }
        }
        trackerCollection.reloadData()
    }
}

// MARK: - EditTracker
extension TrackerViewController: EditTracker {
    func editTracker(category: String, tracker: Tracker) {
        do {
            try trackerStore.updateTracker(newCategory: "updateCategory", tracker: tracker)
        } catch {
            print("Ошибка обновления trackerStore.updateTracker: \(error.localizedDescription)")
        }
        
        updateTrackerData(category: category, tracker: tracker)
        
        print(category, tracker, indexEmoji, indexColor)
        dismiss(animated: true)
    }
}

// MARK: - UIDatePicker
extension UIDatePicker {
    func setTextColor(_ color: UIColor) {
        for subview in self.subviews {
            for nestedView in subview.subviews {
                if let label = nestedView as? UILabel {
                    label.textColor = color
                }
            }
        }
    }
}

extension TrackerViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item), index == 0 { // Предположим, что searchBar находится на первой вкладке
            searchBar.resignFirstResponder() // Убираем клавиатуру при выборе первой вкладки
        }
    }
}

// MARK: - FiltersDelegate
extension TrackerViewController: FiltersDelegate {
    func filter(_ filter: String) {
        dismiss(animated: true)
        currentFilter = filter
        didChangedDatePicker()
        
        trackerCollection.reloadData()
    }
}

// MARK: - TrackerStoreDelegate
extension TrackerViewController: TrackerStoreDelegate {
    func trackerStore(didUpdate update: TrackerStoreUpdate) {
        trackerCollection.performBatchUpdates {
            trackerCollection.reloadItems(at: update.updatedIndexes)
            trackerCollection.insertItems(at: update.insertedIndexes)
            trackerCollection.deleteItems(at: update.deletedIndexes)
        }
    }
}

// MARK: - TrackerRecordStoreDelegate
extension TrackerViewController: TrackerRecordStoreDelegate {
    func trackerRecordStore(didUpdate update: TrackerRecordStoreUpdate) {
        trackerCollection.performBatchUpdates {
            trackerCollection.reloadItems(at: update.updatedIndexes)
            trackerCollection.insertItems(at: update.insertedIndexes)
            trackerCollection.deleteItems(at: update.deletedIndexes)
        }
    }
}
