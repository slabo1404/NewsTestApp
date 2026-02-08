//
//  NewsRepository.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 7.02.26.
//

import Foundation

final class NewsRepository {
    private let newsStorage: INewsStorage
    
    init(newsStorage: INewsStorage) {
        self.newsStorage = newsStorage
    }
}

extension NewsRepository: INewsRepository {
    func fetchNews(urls: [String]) async throws -> AsyncThrowingStream<[Article], Error> {
        AsyncThrowingStream { continuation in
            let task = Task {
                let storageArticles = await newsStorage.fetchNews()
                continuation.yield(storageArticles.sorted(by: >))
                
                do {
                    let rccItems = try await RSSFeedParser.shared.fetchArticlesForMultiple(urls: urls)
                   
                    let articlesFromNetwork = newsStorage.saveNews(rccItems.toObjects())
                    continuation.yield(articlesFromNetwork.sorted(by: >))
                    
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
  
    func updateReadingStatus(articleID: String) {
        newsStorage.setReadingStatus(articleID: articleID)
    }
}
