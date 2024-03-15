import UIKit

final class OnboardingViewController: UIPageViewController {
    private let tabBarViewController = TabBarViewController()
    
    private lazy var pagesViewControllers: [UIViewController] = {
        let vc1 = UIViewController()
        let imageView1 = UIImageView(frame: vc1.view.bounds)
        imageView1.contentMode = .scaleAspectFill
        imageView1.image = UIImage(named: "Onboarding1")
        vc1.view.addSubview(imageView1)

        let vc2 = UIViewController()
        let imageView2 = UIImageView(frame: vc2.view.bounds)
        imageView2.contentMode = .scaleAspectFill
        imageView2.image = UIImage(named: "Onboarding2")
        vc2.view.addSubview(imageView2)
        
        dataSource = self
        delegate = self
        
        return [vc1, vc2]
    }()
    
    private lazy var bigHeadline: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bold32
        label.text = "\(LocalizableKeys.onboardingVCBigHeadline1) \n\(LocalizableKeys.onboardingVCBigHeadline2)"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var litleHeadline: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .medium12
        label.text = "\(LocalizableKeys.onboardingVCLitleHeadline1) \n\(LocalizableKeys.onboardingVCLitleHeadline2)"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .black
        return label
    }()
    
    private lazy var toBeginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.setTitle(LocalizableKeys.onboardingVCToBeginButton, for: .normal)
        button.titleLabel?.font = .medium16
        button.addTarget(self, action: #selector(tapToBegin), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPage = 0
        pageControl.numberOfPages = pagesViewControllers.count
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        pageControl.backgroundColor = .clear
        return pageControl
    }()
    
    override init(transitionStyle: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]?) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let first = pagesViewControllers.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
            constraintsSettingsView()
        }
    }
    
    private func constraintsSettingsView() {
        view.addSubview(bigHeadline)
        view.addSubview(litleHeadline)
        view.addSubview(pageControl)
        view.addSubview(toBeginButton)
        
        NSLayoutConstraint.activate([
            bigHeadline.bottomAnchor.constraint(equalTo: litleHeadline.topAnchor, constant: -16),
            bigHeadline.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            bigHeadline.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            bigHeadline.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            litleHeadline.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -34),
            litleHeadline.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            pageControl.bottomAnchor.constraint(equalTo: toBeginButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            toBeginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            toBeginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toBeginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toBeginButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc private func tapToBegin() {
        tabBarViewController.modalPresentationStyle = .fullScreen
        present(tabBarViewController, animated: true)
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pagesViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = (viewControllerIndex - 1 + pagesViewControllers.count) % pagesViewControllers.count // Зацикливание назад
        return pagesViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pagesViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = (viewControllerIndex + 1) % pagesViewControllers.count // Зацикливание вперёд
        return pagesViewControllers[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pagesViewControllers.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
