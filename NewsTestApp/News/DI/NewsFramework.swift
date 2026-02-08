//
//  NewsFramework.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 8.02.26.
//

import DITranquillity

@MainActor
final class NewsFramework: @preconcurrency DIFramework {
    static func load(container: DIContainer) {
        container.register(RealmNewsStorage.init)
            .as(INewsStorage.self)
        
        container.register(NewsRepository.init(newsStorage:))
            .as(INewsRepository.self)
        
        container.register(FetchNewsUseCase.init(repository:))
            .as(IFetchNewsUseCase.self)
        container.register(UpdateReadingStatusUseCase.init(repository:))
            .as(IUpdateReadingStatusUseCase.self)
        
        container.register(NewsViewModel.init(fetchNewsUseCase:updateReadingStatusUseCase:))
            .as(INewsViewModel.self)
        
        container.register(NewsViewController.init(viewModel:))
    }
}
