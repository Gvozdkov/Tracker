import UIKit
protocol FiltersDelegate: AnyObject {
    func filter(_ filter: String)
}

final class FiltersViewController: UIViewController {
    weak var delegate: FiltersDelegate?
    private var selectedRow: Int?
    private let filtersName = [LocalizableKeys.allTrackers, LocalizableKeys.trackersForToday, LocalizableKeys.completed, LocalizableKeys.notCompleted]
    private lazy var headingLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.font = .medium16
        headingLabel.text = LocalizableKeys.filters
        return headingLabel
    }()
    
    private var filtersTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsViewController()
    }
    
    private func settingsViewController() {
        filtersTableView.dataSource = self
        filtersTableView.delegate = self
        
        view.backgroundColor = ColorsForTheTheme.shared.viewController
        
        view.addSubview(headingLabel)
        view.addSubview(filtersTableView)
        
        
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            filtersTableView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 38),
            filtersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filtersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filtersTableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}

//     MARK: - UITableViewDataSource
    extension FiltersViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filtersName.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NewCategoryCustomCell", for: indexPath) as? NewCategoryCustomCell {
                cell.updateCategorysLabel(filtersName[indexPath.row])  // Присваиваем свойство name категории тексту ячейки
                
                if selectedRow == indexPath.row {
                    cell.clikerNewCategory("ok", filtersName[indexPath.row])
                } else {
                    cell.clikerNewCategory(nil, filtersName[indexPath.row])
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
//
    // MARK: - UITableViewDelegate
    extension FiltersViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedFilter = filtersName[indexPath.row]
            var rowsToUpdate = [indexPath]
            
            if let selectedRow = selectedRow, selectedRow < filtersName.count {
                rowsToUpdate.append(IndexPath(row: selectedRow, section: 0))
            }
            selectedRow = indexPath.row
            tableView.reloadRows(at: rowsToUpdate, with: .none)
            self.delegate?.filter(selectedFilter)
            print(selectedFilter)
        }
    }

