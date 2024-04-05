import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = false
        tabBar.backgroundColor = ColorsForTheTheme.shared.viewController
        tabBar.tintColor = .blue
        
        setupTabBar()
        
        let trackerViewController = TrackerViewController()
        let statisticViewController = StatisticViewController()
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: LocalizableKeys.trackersText,
            image: UIImage(named: "TrackerPicture"),
            selectedImage: nil
        )
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: LocalizableKeys.statistics,
            image: UIImage(named: "Statistic"),
            selectedImage: nil
        )
        viewControllers = [trackerViewController, statisticViewController]
    }
    
    private func setupTabBar() {
        let borderTop = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 0.5))
        borderTop.backgroundColor = .black.withAlphaComponent(0.3)
        tabBar.addSubview(borderTop)
    }
}

