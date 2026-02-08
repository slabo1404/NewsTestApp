//
//  AppDependencyContainer.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 8.02.26.
//

import DITranquillity

final class AppDependencyContainer: DIFramework {
    static let container: DIContainer = {
        let container = DIContainer()
        container.append(framework: NewsFramework.self)
        
        return container
    }()
    
    static func load(container: DIContainer) {}
}
