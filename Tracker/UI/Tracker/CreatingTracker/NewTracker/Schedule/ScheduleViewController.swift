import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didConfirm(_ schedule: [Weekday])
}

final class ScheduleViewController: UIViewController {
    weak var delegate: ScheduleViewControllerDelegate?
    
    private let scheduleCastomCell = ScheduleCastomCell()
    
    private var selectedWeekdays: Set<Weekday> = []
    private let weekdaysLocalizable = [LocalizableKeys.monday, LocalizableKeys.tuesday, LocalizableKeys.wednesday, LocalizableKeys.thursday, LocalizableKeys.friday, LocalizableKeys.saturday, LocalizableKeys.sunday]

    private lazy var headingLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.font = .medium16
        headingLabel.text = LocalizableKeys.schedules
        return headingLabel
    }()
    
    private lazy var scheduleTable: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = ColorsForTheTheme.shared.table
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = ColorsForTheTheme.shared.separator
        tableView.separatorInset = .init(top: tableView.bounds.height / 2, left: 15, bottom: tableView.bounds.height / 2, right: 15)
        tableView.register(ScheduleCastomCell.self, forCellReuseIdentifier: "ScheduleCastomCell")
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var confirmationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorsForTheTheme.shared.buttonAction
        button.setTitleColor(ColorsForTheTheme.shared.ButtonText, for: .normal)
        button.layer.cornerRadius = 16
        button.setTitle(LocalizableKeys.done, for: .normal)
        button.titleLabel?.font = .medium16
        button.addTarget(self, action: #selector(confirmationButtonAction), for: .touchUpInside)
        button.isEnabled = true
        return button
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
        
        scheduleCastomCell.delegate = self
        
        settingsViewController()
    }
    
    private func settingsViewController() {
        view.backgroundColor = ColorsForTheTheme.shared.viewController
        view.addSubview(headingLabel)
        view.addSubview(scheduleTable)
        view.addSubview(confirmationButton)
        
        
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scheduleTable.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 40),
            scheduleTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scheduleTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scheduleTable.heightAnchor.constraint(equalToConstant: 525),
            
            confirmationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            confirmationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmationButton.heightAnchor.constraint(equalToConstant: 60),
            
        ])
    }
    
    @objc private func confirmationButtonAction() {
        let weekdays = Array(selectedWeekdays).sorted()
        delegate?.didConfirm(weekdays)
        print(weekdays)
    }
}

// MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekdaysLocalizable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCastomCell", for: indexPath) as? ScheduleCastomCell {
            let weekday = Weekday.allCases[indexPath.row]
            cell.configureCell(weekday, weekdaysLocalizable[indexPath.row])
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        } else {
            assertionFailure("Error - ScheduleCastomCell")
            return UITableViewCell()
        }
    }
}

extension ScheduleViewController: ScheduleCastomCellDelegate {
    func uISwitch(uISwitch: Bool, weekday: Weekday) {
        if uISwitch == true {
            selectedWeekdays.insert(weekday)
        } else {
            selectedWeekdays.remove(weekday)
        }
    }
}
