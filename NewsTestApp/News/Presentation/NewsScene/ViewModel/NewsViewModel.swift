//
//  NewsViewModel.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 6.02.26.
//

import Combine
import Foundation
import FeedKit

protocol INewsVIewModelOutput {
    var articlesPublisher: AnyPublisher<[Article], Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorStringPublisher: AnyPublisher<String?, Never> { get }
}

protocol INewsViewModelInput {
    func fetchArticles() async throws
}

protocol INewsViewModel: INewsViewModelInput, INewsVIewModelOutput {}

final class NewsViewModel: ObservableObject, INewsViewModel {
    @Published private var articles: [Article] = []
    @Published private var isLoading: Bool = false
    @Published private var errorString: String?
    
    // MARK: - Outputs
    
    var articlesPublisher: AnyPublisher<[Article], Never> {
        $articles.eraseToAnyPublisher()
    }
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }
    
    var errorStringPublisher: AnyPublisher<String?, Never> {
        $errorString.eraseToAnyPublisher()
    }

    func fetchArticles() async throws {
        isLoading = true
        
        do {
            articles = try await RSSFeedParser.shared.fetchArticlesForMultiple(urls: ArticleSource.actualURLs)
            isLoading = false
        } catch let error as RSSFeedParserError {
            errorString = error.errorDescription.orEmpty
        }
    }
}
