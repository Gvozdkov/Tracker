import UIKit

protocol ScheduleCastomCellDelegate: AnyObject {
    func uISwitch(uISwitch: Bool, weekday: Weekday)
}

final class ScheduleCastomCell: UITableViewCell {
    private var weekday: Weekday?
    weak var delegate: ScheduleCastomCellDelegate?
    private var selectedSwitch = false
    
    private lazy var scheduleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var uISwitch: UISwitch = {
        let uISwitch = UISwitch()
        uISwitch.onTintColor = .blue
        uISwitch.translatesAutoresizingMaskIntoConstraints = false
        uISwitch.addTarget(self, action: #selector(didToggleSwitchView), for: .valueChanged)
        return uISwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        settingsCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        assertionFailure("init(coder:) has not been implemented")
    }
    
    private func settingsCell() {
        contentView.addSubview(scheduleLabel)
        contentView.addSubview(uISwitch)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 75),
            
            scheduleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            scheduleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            scheduleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            uISwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            uISwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    
    func configureCell(_ weekday: Weekday, _ weekdaysLocalizable: String) {
        self.weekday = weekday
        scheduleLabel.text = weekdaysLocalizable
    }
    
    @objc private func didToggleSwitchView(_ sender: UISwitch) {

        guard let weekday else { return }
        if uISwitch.isOn {
            selectedSwitch = true
            delegate?.uISwitch(uISwitch: true, weekday: weekday)
            print("передаю данные \(selectedSwitch) \(weekday)")
        } else {
            selectedSwitch = false
            delegate?.uISwitch(uISwitch: false, weekday: weekday)
            print("передаю данные \(selectedSwitch) \(weekday)")
        }
        
    }
}
