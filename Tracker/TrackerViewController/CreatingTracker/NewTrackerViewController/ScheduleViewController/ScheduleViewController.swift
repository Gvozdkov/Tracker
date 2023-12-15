import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {  // делегат говорит, что пользователь подтвердил выбранный график
    func didConfirm(_ schedule: [Weekday])
}

final class ScheduleViewController: UIViewController {
    weak var delegate: ScheduleViewControllerDelegate?
    
    private let scheduleCastomCell = ScheduleCastomCell()
    
    private var selectedWeekdays: Set<Weekday> = []
    
    private lazy var headingLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.font = .medium16
        headingLabel.text = "Расписание"
        return headingLabel
    }()
    
    private lazy var scheduleTable: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .backgroundDay
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: tableView.bounds.height / 2, left: 15, bottom: tableView.bounds.height / 2, right: 15)
        tableView.register(ScheduleCastomCell.self, forCellReuseIdentifier: "ScheduleCastomCell")
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var confirmationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .medium16
        button.addTarget(self, action: #selector(confirmationButtonAction), for: .touchUpInside)
        button.isEnabled = true
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
        
        scheduleCastomCell.delegate = self
        
        settingsViewController()
    }
    
    private func settingsViewController() {
        view.backgroundColor = .white
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
        return Weekday.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCastomCell", for: indexPath) as? ScheduleCastomCell {
            let weekday = Weekday.allCases[indexPath.row]
            cell.configureCell(with: weekday)
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        } else {
            fatalError("Error - ScheduleCastomCell")
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
