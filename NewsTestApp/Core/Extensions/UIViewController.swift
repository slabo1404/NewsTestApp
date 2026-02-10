//
//  UIViewController.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 10.02.26.
//

import UIKit

extension UIViewController {
    func safePresent(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        if let tabBarController {
            tabBarController.present(viewControllerToPresent, animated: animated, completion: completion)
        } else {
            if let navigationController {
                navigationController.present(viewControllerToPresent, animated: animated, completion: completion)
            } else {
                present(viewControllerToPresent, animated: animated, completion: completion)
            }
        }
    }
}


