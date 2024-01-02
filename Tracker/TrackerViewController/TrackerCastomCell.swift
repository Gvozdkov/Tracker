import UIKit

protocol TrackerCellDelegate: AnyObject {
    func trackerRecord(tracker:Tracker, completed: Bool)
}

final class TrackerCastomCell: UICollectionViewCell {
    weak var delegate: TrackerCellDelegate?
    
    private lazy var frameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = .blue
        return view
    }()
    
    private lazy var gradient: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        label.textAlignment = .center
        label.font = .medium12
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .medium12
        label.textColor = .white
        return label
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .medium12
        label.textColor = .blackDay
        label.text = textDayLabel
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        button.backgroundColor = .blue
        button.tintColor = .white
        return button
    }()
    
    private var imageButton = UIImage(systemName: "plus")
    private var counter = 0
    private var textDayLabel = "0 дней"

    private var tracker: Tracker = Tracker(id: UUID(), name: "", emoji: "", color: .black, schedule: [])
    private var trackerCompleted: Bool = false {
        didSet {
            executionDayCheck()
        }
    }
    
//    private var trackerRecord = TrackerRecord(trackerId: UUID(), date: Date())
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraintsSettingsView()
        executionDayCheck()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constraintsSettingsView() {
        frameView.addSubview(colorView)
        colorView.addSubview(gradient)
        colorView.addSubview(nameLabel)
        colorView.addSubview(emojiLabel)
        gradient.addSubview(emojiLabel)
        frameView.addSubview(dayLabel)
        frameView.addSubview(button)
        
        contentView.addSubview(frameView)
        
        NSLayoutConstraint.activate([
            frameView.widthAnchor.constraint(equalToConstant: 167),
            frameView.heightAnchor.constraint(equalToConstant: 148),
            
            colorView.leadingAnchor.constraint(equalTo: frameView.leadingAnchor),
            colorView.topAnchor.constraint(equalTo: frameView.topAnchor),
            colorView.trailingAnchor.constraint(equalTo: frameView.trailingAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 167),
            colorView.heightAnchor.constraint(equalToConstant: 90),
            
            gradient.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            gradient.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            gradient.widthAnchor.constraint(equalToConstant: 24),
            gradient.heightAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: gradient.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: gradient.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 44),
            nameLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12),
            nameLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            nameLabel.widthAnchor.constraint(equalToConstant: 143),
            nameLabel.heightAnchor.constraint(equalToConstant: 34),
            
            dayLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            dayLabel.leadingAnchor.constraint(equalTo: frameView.leadingAnchor, constant: 12),
            dayLabel.widthAnchor.constraint(equalToConstant: 101),
            dayLabel.heightAnchor.constraint(equalToConstant: 18),
            
            button.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: frameView.trailingAnchor, constant: -12),
            button.widthAnchor.constraint(equalToConstant: 34),
            button.heightAnchor.constraint(equalToConstant: 34),
        ])
    }
    
    private func formatDayText() {
        switch counter {
        case 1:
            dayLabel.text = "\(counter) день"
        case 2...4:
            dayLabel.text = "\(counter) дня"
        default:
            dayLabel.text = "\(counter) дней"
        }
    }
    
//    func updateData(title: String, schedule: [Weekday]?, color: UIColor?, emoji: String?, label: String, trackerRecord: TrackerRecord, trackerCompleted: Bool) {
    
    func updateData(tracker: Tracker, trackerCompleted: Bool) {
        colorView.backgroundColor = tracker.color
        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.name
        button.backgroundColor = tracker.color
        self.trackerCompleted = trackerCompleted
        self.tracker = tracker
//        self.trackerRecord = trackerRecord

//        print("передал в ячейку \(trackerRecord) \(trackerCompleted)")
    }
    
    private func executionDayCheck() {
        switch trackerCompleted {
        case true:
            formatDayText()
            button.alpha = 0.3
            imageButton = UIImage(systemName: "checkmark")
            button.setImage(imageButton, for: .normal)
            
        case false:
            formatDayText()
            button.alpha = 1
            imageButton = UIImage(systemName: "plus")
            button.setImage(imageButton, for: .normal)
        }
    }
    
    @objc private func tapButton() {
        if trackerCompleted {
            counter -= 1
            executionDayCheck()
            trackerCompleted = !trackerCompleted
        } else {
            counter += 1
            executionDayCheck()
            trackerCompleted = !trackerCompleted
        }
        delegate?.trackerRecord(tracker: tracker, completed: trackerCompleted)
        print("отправил через делегат  \(tracker) \(trackerCompleted)")
    }
}

