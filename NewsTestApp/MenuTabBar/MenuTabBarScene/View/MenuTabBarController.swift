//
//  MenuTabBarController.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 6.02.26.
//

import UIKit
import DITranquillity

final class MenuTabBarController: UITabBarController {
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newsViewController: NewsViewController = AppDependencyContainer.container.resolve()
        let newsNavigationController = UINavigationController(rootViewController: newsViewController)
                
        newsNavigationController.tabBarItem = UITabBarItem(
            title: "Новости",
            image: UIImage(systemName: "text.bubble.badge.clock"),
            selectedImage: UIImage(systemName: "text.bubble.badge.clock.fill")
        )
        
        let settingsViewController = UIViewController()
        settingsViewController.tabBarItem = UITabBarItem(
            title: "Настройки",
            image: UIImage(systemName: "rectangle.grid.1x3"),
            selectedImage: UIImage(systemName: "rectangle.grid.1x3.fill")
        )
        
        viewControllers = [
            newsNavigationController,
            settingsViewController
        ]
    }
}
