//
//  SettingsFramework.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 9.02.26.
//

import DITranquillity

@MainActor
final class SettingsFramework: @preconcurrency DIFramework {
    static func load(container: DIContainer) {
        container.register(SettingsViewModel.init)
            .as(ISettingsViewModel.self)
        
        container.register(SettingsViewCotroller.init(viewModel:))
    }
}
