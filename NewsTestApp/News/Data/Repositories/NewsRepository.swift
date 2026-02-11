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
        let storage = newsStorage
        
        return AsyncThrowingStream { continuation in
            let task = Task.detached(priority: .utility) {
                let storageArticles = await storage.fetchNews()
                continuation.yield(storageArticles)
                
                do {
                    let rccItems = try await RSSFeedParser.shared.fetchArticlesForMultiple(urls: urls)
                    let articlesFromNetwork = await storage.saveNews(rccItems.toObjects())
                    
                    continuation.yield(articlesFromNetwork)
                    continuation.finish()
                } catch {
                    if let rssError = error as? RSSFeedParserError, rssError == .emptyUrls {
                        await storage.saveNews([])
                        continuation.yield([])
                        continuation.finish(throwing: error)
                    } else {
                        continuation.finish()
                    }
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
