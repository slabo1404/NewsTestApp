//
//  FetchNewsUseCase.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 7.02.26.
//

import Foundation

protocol IFetchNewsUseCase {
    func start(urls: [String]) async throws -> AsyncThrowingStream<[Article], Error>
}

final class FetchNewsUseCase: IFetchNewsUseCase {
    private let repository: INewsRepository
    
    init(repository: INewsRepository) {
        self.repository = repository
    }
    
    func start(urls: [String]) async throws -> AsyncThrowingStream<[Article], Error> {
        try await repository.fetchNews(urls: urls)
    }
}
