//
//  USTabBarViewController.swift
//  SomuYadavDemo
//
//  Created by Somendra Yadav on 25/08/25.
//
import UIKit

final class USTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Properties
    
    /// The view representing the selection indicator.
    private let selectionIndicator = UIView()
    
    /// The width of the selection indicator.
    private var indicatorWidth: CGFloat {
        let count = CGFloat(tabBar.items?.count ?? 1)
        return count > 0 ? tabBar.bounds.width / count : 0
    }
    
    /// The color of the selection indicator.
    var indicatorColor: UIColor = UIColor(hex: 0x000435)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationUI()
        delegate = self
        
        setupSelectionIndicator()
        setupViewControllers()
        setupTabBarAppearance()
        
        // Default selected tab
        selectedIndex = 2
        moveSelectionIndicator(to: selectedIndex, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Keep indicator aligned after rotations/safe-area/tab bar size changes
        moveSelectionIndicator(to: selectedIndex, animated: false)
    }
    
    // MARK: - Setup
    
    /// Sets up the selection indicator appearance and behavior
    private func setupSelectionIndicator() {
        selectionIndicator.backgroundColor = indicatorColor
        selectionIndicator.frame = CGRect(x: 0, y: 0, width: indicatorWidth, height: 3)
        tabBar.addSubview(selectionIndicator)
    }
    
    /// Creates and assigns view controllers for the tab bar
    private func setupViewControllers() {
        let watchlistVC = UIViewController()
        watchlistVC.view.backgroundColor = .white
        watchlistVC.tabBarItem = UITabBarItem(title: "Watchlist", image: UIImage(systemName: "list.bullet"), tag: 0)
        
        let orderVC = UIViewController()
        orderVC.view.backgroundColor = .white
        orderVC.tabBarItem = UITabBarItem(title: "Orders", image: UIImage(systemName: "arrow.clockwise.circle"), tag: 1)
        
        let repository = HoldingsRepository()
        let viewModel = HoldingsViewModel(repository: repository)
        let holdingsVC = HoldingsViewController(viewModel: viewModel)
        holdingsVC.view.backgroundColor = .white
        holdingsVC.tabBarItem = UITabBarItem(title: "Portfolio", image: UIImage(systemName: "bag"), tag: 2)
        
        let fundsVC = UIViewController()
        fundsVC.view.backgroundColor = .white
        fundsVC.tabBarItem = UITabBarItem(title: "Funds", image: UIImage(systemName: "indianrupeesign.circle"), tag: 4)
        
        let investVC = UIViewController()
        investVC.view.backgroundColor = .white
        investVC.tabBarItem = UITabBarItem(title: "Invest", image: UIImage(systemName: "eyeglasses"), tag: 5)
        
        viewControllers = [watchlistVC, orderVC, holdingsVC, fundsVC, investVC]
    }
    
    /// Configures the tab bar's appearance
    private func setupTabBarAppearance() {
        tabBar.tintColor = UIColor(hex: 0x000435)
        tabBar.unselectedItemTintColor = .darkGray
        tabBar.backgroundColor = .lightGray
        tabBar.barTintColor = UIColor(hex: 0x000435)
        tabBar.isTranslucent = false
        tabBar.layer.cornerRadius = 12
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.clipsToBounds = true
    }
    
    // MARK: - Navigation Bar
    
    /// Sets up the navigation bar items
    func setUpNavigationUI() {
        view.backgroundColor = .white
        
        let personBarButton = makeBarButtonItem(imageName: "person.crop.circle", size: CGSize(width: 45, height: 45))
        let title = UIBarButtonItem(title: "Portfolio", image: nil, primaryAction: nil, menu: nil)
        let arrowBarButton = makeBarButtonItem(imageName: "arrow.up.arrow.down", size: CGSize(width: 30, height: 30))
        let searchBarButton = makeBarButtonItem(imageName: "magnifyingglass", size: CGSize(width: 30, height: 30))
        let lineBarButton = makeBarButtonItem(imageName: "line", size: CGSize(width: 5, height: 30))
        
        navigationItem.leftBarButtonItems = [personBarButton, title]
        navigationItem.rightBarButtonItems = [searchBarButton, lineBarButton, arrowBarButton]
    }

    /// Creates a bar button item with the specified image and size.
    private func makeBarButtonItem(imageName: String, size: CGSize) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: imageName) ?? UIImage(named: imageName)
        button.setImage(image, for: .normal)
        button.frame = CGRect(origin: .zero, size: size)
        return UIBarButtonItem(customView: button)
    }
    
    // MARK: - Selection Indicator
    
    /// Moves the selection indicator to the specified tab index
    func moveSelectionIndicator(to index: Int, animated: Bool) {
        let itemWidth = tabBar.bounds.width / CGFloat(tabBar.items?.count ?? 1)
        let xPosition = CGFloat(index) * itemWidth
        let updates = { [self] in
            selectionIndicator.frame = CGRect(
                x: xPosition,
                y: 0,
                width: indicatorWidth,
                height: 3
            )
        }
        animated ? UIView.animate(withDuration: 0.25, animations: updates) : updates()
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
            moveSelectionIndicator(to: index, animated: true)
        }
    }
}
