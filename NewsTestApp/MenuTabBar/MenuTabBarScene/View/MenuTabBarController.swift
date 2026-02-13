//
//  MenuTabBarController.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 6.02.26.
//

import UIKit
import DITranquillity

final class MenuTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        
        setupTabBarAppearance()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let newsVC: NewsViewController = AppDependencyContainer.container.resolve()
        let settingsVC: SettingsViewCotroller = AppDependencyContainer.container.resolve()
        
        viewControllers = [
            createNavigationController(root: newsVC, title: "Новости", icon: "text.bubble.badge.clock"),
            createNavigationController(root: settingsVC, title: "Настройки", icon: "rectangle.grid.1x3")
        ]
    }
    
    private func createNavigationController(root: UIViewController, title: String, icon: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: root)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        
        nav.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: icon),
            selectedImage: UIImage(systemName: "\(icon).fill")
        )
        
        return nav
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
