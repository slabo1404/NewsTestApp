//
//  RSSFeedItem+RSSFeedItemMappable.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 6.02.26.
//

import FeedKit

protocol RSSFeedItemMappable {
    func toArticle() -> Article
}

extension RSSFeedItem: RSSFeedItemMappable {
    func toArticle() -> Article {
        return Article(
            id: link ?? title.orEmpty,
            title: title.orEmpty,
            description: description.orEmpty,
            link: link.orEmpty
        )
    }
}

extension Collection where Iterator.Element: RSSFeedItemMappable {
    func toArticles() -> [Article] {
        map { $0.toArticle() }
    }
}
