import UIKit

protocol SubCategoryProtocol: AnyObject {
    func selectedCategory(category: String?)
}

final class CategoryViewController: UIViewController {
    weak var delegate: SubCategoryProtocol?
    private let newCategoryViewController = NewCategoryViewController()
    private var image = "ok"
    private var selectedRow: Int?
    private var selectCategory = ""
    
    private lazy var headingLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.font = .medium16
        headingLabel.text = "Категория"
        return headingLabel
    }()
    
    private var newCategoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .backgroundDay
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: tableView.bounds.height / 2, left: 15, bottom: tableView.bounds.height / 2, right: 15)
        tableView.register(NewCategoryCustomCell.self, forCellReuseIdentifier: "NewCategoryCustomCell")

        return tableView
    }()
    
    private lazy var starImageView: UIImageView = {
        let starImageView = UIImageView()
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        return starImageView
    }()
    
    private lazy var questionLabel: UILabel = {
        let text = "Привычки и события можно \nобъединить по смыслу"
        let questionLabel = UILabel()
        questionLabel.font = .medium12
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 2
        
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        return questionLabel
    }()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = .medium16
        button.addTarget(self, action: #selector(addCategoryButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newCategorysIsEmpty()
        newCategoryViewController.delegate = self
        settingsViewController()
        
    }
    
    private func settingsViewController() {
        newCategoryTableView.dataSource = self
        newCategoryTableView.delegate = self
        
        view.backgroundColor = .white
        
        view.addSubview(headingLabel)
        view.addSubview(starImageView)
        view.addSubview(questionLabel)
        view.addSubview(habitButton)
        view.addSubview(newCategoryTableView)
        
        
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            newCategoryTableView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 24),
            newCategoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newCategoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newCategoryTableView.bottomAnchor.constraint(equalTo: habitButton.topAnchor, constant: -114.0),
            
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
    
    private func newCategorysIsEmpty() {
        if UserCategorys.userCategory != nil {
            newCategoryTableView.isHidden = false
            questionLabel.text = nil
            starImageView.image = nil
        }
        newCategoryTableView.reloadData()
    }
    
    @IBAction private func addCategoryButtonAction() {
        self.present(newCategoryViewController, animated: false)
    }
}


extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let userCategories = UserCategorys.userCategory {
            print("Number of categories: \(userCategories.count)")
            return userCategories.count
        } else {
            print("User categories array is nil")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewCategoryCustomCell", for: indexPath) as? NewCategoryCustomCell {
            cell.categorysLabel.text = UserCategorys.userCategory?[indexPath.row]// Присваиваем свойство name категории тексту ячейки
            if selectedRow == indexPath.row {
                cell.clikerNewCategory(image)
            } else {
                cell.clikerNewCategory(nil)
            }
            cell.backgroundColor = .clear
//            cell.layer.cornerRadius = 16
            cell.selectionStyle = .none
            return cell
        } else {
            fatalError("Error - NewCategoryCustomCell")
        }
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var rowsToUpdate = [indexPath]
        
        if let selectedRow = selectedRow, selectedRow < UserCategorys.userCategory?.count ?? 0 {
            rowsToUpdate.append(IndexPath(row: selectedRow, section: 0))
        }
        selectedRow = indexPath.row
        tableView.reloadRows(at: rowsToUpdate, with: .none)
        
        selectCategory = UserCategorys.userCategory?[indexPath.row] ?? ""
        self.delegate?.selectedCategory(category: selectCategory)
    }
}


extension CategoryViewController: NewSaveCategoryDelegate {
    func saveCategory(category: String?) {
        if let category = category {
            dismiss(animated: true)
            UserCategorys.userCategory = (UserCategorys.userCategory ?? []) + [category]
            newCategoryTableView.reloadData()
            newCategorysIsEmpty()
        }
    }
}
