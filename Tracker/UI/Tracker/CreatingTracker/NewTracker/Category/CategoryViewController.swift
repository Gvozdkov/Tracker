import UIKit

protocol SubCategoryProtocol: AnyObject {
    func selectedCategory(category: String?)
}

final class CategoryViewController: UIViewController {
    weak var delegate: SubCategoryProtocol?
    private let newCategoryViewController = NewCategoryViewController()
    private let viewModel: CategoryViewModel
    private var selectedRow: Int?
    
    private lazy var headingLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.font = .medium16
        headingLabel.text = LocalizableKeys.category
        return headingLabel
    }()
    
    private var userCategoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.backgroundColor = ColorsForTheTheme.shared.table
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
            headingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userCategoryTableView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 24),
            userCategoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userCategoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userCategoryTableView.bottomAnchor.constraint(equalTo: habitButton.topAnchor, constant: -114.0),
            
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
            questionLabel.text = LocalizableKeys.categoryVCQuestionLabelText
            starImageView.image = UIImage(named: "Star")
        } else {
            userCategoryTableView.isHidden = false
            questionLabel.text = nil
            starImageView.image = nil
        }
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
extension CategoryViewController: NewSaveCategoryDelegate {
    func saveCategory(category: String?) {
        if let category = category {
            dismiss(animated: true)
            viewModel.model.addNewTrackerCategory(category)
            userCategoryTableView.reloadData()
            userCategoryIsEmpty()
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
