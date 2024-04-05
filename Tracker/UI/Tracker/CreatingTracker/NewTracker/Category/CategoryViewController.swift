import UIKit

protocol SubCategoryProtocol: AnyObject {
    func selectedCategory(category: String?)
}

final class CategoryViewController: UIViewController {
    weak var delegate: SubCategoryProtocol?
    private let newCategoryViewController = NewCategoryViewController()
    private let viewModel: CategoryViewModel
    private var selectedRow: Int?
    var selectedCategoty = ""
    
    private lazy var headingLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.font = .medium16
        headingLabel.text = LocalizableKeys.category
        return headingLabel
    }()
    
    var userCategoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = ColorsForTheTheme.shared.separator
        tableView.separatorInset = .init(top: tableView.bounds.height / 2,
                                         left: 15, bottom: tableView.bounds.height / 2,
                                         right: 15)
        tableView.register(NewCategoryCustomCell.self, forCellReuseIdentifier: "NewCategoryCustomCell")
        return tableView
    }()
    
    private lazy var starImageView: UIImageView = {
        let starImageView = UIImageView()
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.image = UIImage(named: "Star")
        return starImageView
    }()
    
    private lazy var questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.font = .medium12
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 2
        questionLabel.text = LocalizableKeys.categoryVCQuestionLabel
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        return questionLabel
    }()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorsForTheTheme.shared.buttonAction
        button.setTitleColor(ColorsForTheTheme.shared.ButtonText, for: .normal)
        button.layer.cornerRadius = 16
        button.setTitle(LocalizableKeys.categoryVCHabitButton, for: .normal)
        button.titleLabel?.font = .medium16
        button.addTarget(self, action: #selector(addCategoryButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        let viewModel = CategoryViewModel(model: CategoryModel())
        self.viewModel = viewModel
        super.init(coder: coder)
        assertionFailure("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.model.fetchAllTrackerCategory()
        userCategoryIsEmpty()
        
        sizeTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newCategoryViewController.delegate = self
        settingsViewController()
    }
    
    
    
    private func settingsViewController() {
        userCategoryTableView.dataSource = self
        userCategoryTableView.delegate = self
        
        view.backgroundColor = ColorsForTheTheme.shared.viewController
        
        view.addSubview(headingLabel)
        view.addSubview(starImageView)
        view.addSubview(questionLabel)
        view.addSubview(habitButton)
        view.addSubview(userCategoryTableView)
        
        
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headingLabel.heightAnchor.constraint(equalToConstant: 22),
            
            userCategoryTableView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 24),
            userCategoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userCategoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userCategoryTableView.bottomAnchor.constraint(equalTo: habitButton.topAnchor, constant: -16),
            
            starImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            starImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            questionLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 8),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            habitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func userCategoryIsEmpty() {
        if viewModel.model.userCategory.isEmpty {
            userCategoryTableView.isHidden = true
            questionLabel.text = "\(LocalizableKeys.categoryVCQuestionLabelText1) \n\(LocalizableKeys.categoryVCQuestionLabelText2)"
            starImageView.image = UIImage(named: "Star")
        } else {
            userCategoryTableView.isHidden = false
            questionLabel.text = nil
            starImageView.image = nil
        }
    }
    
    private func sizeTable() {
        let maxTableHeight: CGFloat = 300
        let rowHeight: CGFloat = 75.0
        let defaultTableHeight: CGFloat = max(min(CGFloat(viewModel.model.userCategory.count) * rowHeight, maxTableHeight), rowHeight)
        
        
        userCategoryTableView.isScrollEnabled = true
        userCategoryTableView.heightAnchor.constraint(equalToConstant: defaultTableHeight).isActive = true
        
        userCategoryTableView.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        UIView.performWithoutAnimation {
            userCategoryTableView.frame.size.height = defaultTableHeight
            userCategoryTableView.reloadData()
            userCategoryTableView.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        settingsViewController()
        userCategoryTableView.reloadData()
    }
    
    @IBAction private func addCategoryButtonAction() {
        self.present(newCategoryViewController, animated: false)
    }
}

// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.userCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewCategoryCustomCell", for: indexPath) as? NewCategoryCustomCell {
            cell.updateCategorysLabel(viewModel.model.userCategory[indexPath.row])  // Присваиваем свойство name категории тексту ячейки
            
            if selectedRow == indexPath.row {
                cell.clikerNewCategory("ok", viewModel.model.userCategory[indexPath.row])
            } else {
                cell.clikerNewCategory(nil, viewModel.model.userCategory[indexPath.row])
            }
            
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            return cell
        } else {
            assertionFailure("Error - NewCategoryCustomCell")
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var rowsToUpdate = [indexPath]
        sizeTable()
        if let selectedRow = selectedRow, selectedRow < viewModel.model.userCategory.count {
            rowsToUpdate.append(IndexPath(row: selectedRow, section: 0))
        }
        selectedRow = indexPath.row
        tableView.reloadRows(at: rowsToUpdate, with: .none)
        viewModel.model.selectCategory = viewModel.model.userCategory[indexPath.row]
        self.delegate?.selectedCategory(category: viewModel.model.selectCategory)

    }
}

// MARK: - NewSaveCategoryDelegate
//extension CategoryViewController: NewSaveCategoryDelegate {
//    func saveCategory(category: String?) {
//        if let category = category {
//            dismiss(animated: true)
//            
//            // Обновляем данные модели и добавляем новую категорию
//            viewModel.model.addNewTrackerCategory(category)
//            
//            // Определяем индекс добавленной категории
//            let newIndex = viewModel.model.userCategory.count - 1
//            let newIndexPath = IndexPath(row: newIndex, section: 0)
//            
//            // Выполняем вставку новой строки в таблицу
//            userCategoryTableView.performBatchUpdates({
//                userCategoryTableView.insertRows(at: [newIndexPath], with: .automatic)
//            }) { [weak self] _ in
//                guard let self = self else { return }
//                self.sizeTable() // Вызов метода после успешного обновления таблицы
//                self.userCategoryTableView.reloadData()
//                self.userCategoryIsEmpty()
//            }
//        }
//    }
//}
extension CategoryViewController: NewSaveCategoryDelegate {
    func saveCategory(category: String?) {
        if let category = category {
            viewModel.model.addNewTrackerCategory(category)
            DispatchQueue.main.async{
                self.sizeTable()
            }
            
            userCategoryIsEmpty()
            dismiss(animated: true)
        }
    }
}

// MARK: - TrackerCategoryStoreDelegate
extension CategoryViewController: TrackerCategoryStoreDelegate {
    func trackerCategoryStore(didUpdate update: TrackerCategoryStoreUpdate) {
        userCategoryTableView.performBatchUpdates {
            userCategoryTableView.reloadSections(update.updatedSectionIndexes, with: UITableView.RowAnimation.automatic)
            userCategoryTableView.insertSections(update.insertedSectionIndexes, with: UITableView.RowAnimation.automatic)
            userCategoryTableView.deleteSections(update.deletedSectionIndexes, with: UITableView.RowAnimation.automatic)
        }
    }
}
