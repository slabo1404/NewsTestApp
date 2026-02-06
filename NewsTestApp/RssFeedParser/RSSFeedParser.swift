//
//  RSSFeedParser.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 6.02.26.
//

import FeedKit
import Foundation

final class RSSFeedParser {
    static let shared = RSSFeedParser()
    
    private init() {}
    
    // MARK: - fetch articles for multiple urls
    
    func fetchArticlesForMultiple(urls urlStrings: [String]) async throws -> [Article] {
        try await withThrowingTaskGroup(of: [RSSFeedItem].self) { group in
            for urlStr in urlStrings {
                group.addTask {
//                    try await self.fetchRSSItems(for: urlStr)
                    do {
                        return try await self.fetchRSSItems(for: urlStr)
                    } catch {
                        print("Неверынй url: \(urlStr)")
                        return []
                    }
                }
            }
            
            var result = [RSSFeedItem]()
            
            for try await batch in group {
                result.append(contentsOf: batch)
            }
            
            guard !result.isEmpty else {
                throw RSSFeedParserError.noData
            }
            
            let sortedResult = result.sorted { ($0.pubDate ?? Date.distantPast) > ($1.pubDate ?? Date.distantPast) }
            
            return sortedResult.toArticles()
        }
    }
    
    // MARK: - fetch articles for single url
    
    func fetchArticles(for urlString: String) async throws -> [Article] {
        try await fetchRSSItems(for: urlString).toArticles()
    }
    
    // MARK: - fetch [RSSFeedItem] for single url
    
    private func fetchRSSItems(for urlString: String) async throws -> [RSSFeedItem] {
        guard let url = URL(string: urlString) else {
            throw RSSFeedParserError.invalidURL
        }
        
        let feed = try await Feed(remoteURL: url)
        
        guard case .rss(let rssFeed) = feed else {
            throw RSSFeedParserError.noData
        }
        
        return rssFeed.channel?.items ?? []
    }
}
