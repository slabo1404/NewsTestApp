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
    var errorMessagePublisher: AnyPublisher<String?, Never> { get }
    var articleChangesPublisher: AnyPublisher<(insertions: [IndexPath], removals: [IndexPath]), Never> { get }
    var updatedArticleIndexPublisher: AnyPublisher<Int, Never> { get }
}

protocol INewsViewModelInput {
    func fetchArticles() async throws
    func updateReadingStatus(article: Article)
}

protocol INewsViewModel: INewsViewModelInput, INewsVIewModelOutput {}

final class NewsViewModel: ObservableObject, INewsViewModel {
    @Published private var articles: [Article] = []
    @Published private var isLoading: Bool = true
    private var errorMessage = PassthroughSubject<String?, Never>()
    private var articleChanges = PassthroughSubject<(insertions: [IndexPath], removals: [IndexPath]), Never>()
    private var updateArticleAtIndex = PassthroughSubject<Int, Never>()
    
    private let fetchNewsUseCase: IFetchNewsUseCase
    private let updateReadingStatusUseCase: IUpdateReadingStatusUseCase
    
    init(
        fetchNewsUseCase: IFetchNewsUseCase,
        updateReadingStatusUseCase: IUpdateReadingStatusUseCase
    ) {
        self.fetchNewsUseCase = fetchNewsUseCase
        self.updateReadingStatusUseCase = updateReadingStatusUseCase
    }
    
    // MARK: - Outputs
    
    var articlesPublisher: AnyPublisher<[Article], Never> {
        $articles.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading
            .prefix(2)
            .eraseToAnyPublisher()
    }
    
    var errorMessagePublisher: AnyPublisher<String?, Never> {
        errorMessage.eraseToAnyPublisher()
    }
    
    var articleChangesPublisher: AnyPublisher<(insertions: [IndexPath], removals: [IndexPath]), Never> {
        articleChanges.eraseToAnyPublisher()
    }
    
    var updatedArticleIndexPublisher: AnyPublisher<Int, Never> {
        updateArticleAtIndex.eraseToAnyPublisher()
    }
    
    // MARK: - Inputs
    
    func fetchArticles() async throws {
        let sources = SharedPreferences.selectedSources
        let urls = sources.map { (ArticleSource(rawValue: $0)?.url).orEmpty }
        
        do {
            let stream = try await fetchNewsUseCase.start(urls: urls)
            
            for try await updatedAtritcle in stream {
                let oldArticles = articles
                articles = updatedAtritcle
                articleChanges.send(updatedAtritcle.fetchDifferences(from: oldArticles))
                isLoading = false
            }
        } catch let error as RSSFeedParserError {
            isLoading = false
            errorMessage.send(error.errorDescription)
        }
    }
    
    func updateReadingStatus(article: Article) {
        guard let index = articles.firstIndex(where: { $0.id == article.id }) else { return }
        
        updateReadingStatusUseCase.start(articleID: article.id)
        
        var updatedArticle = articles[index]
        updatedArticle.isRead = true
        
        articles[index] = updatedArticle
        updateArticleAtIndex.send(index)
    }
}
