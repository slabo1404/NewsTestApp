//
//  RSSFeedItem+RSSFeedItemMappable.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 6.02.26.
//

import FeedKit
import Foundation
import RealmSwift
import XMLKit

protocol RSSFeedItemMappable {
    func toArticle() -> Article
}

extension RSSFeedItem: RSSFeedItemMappable {
    func toArticle() -> Article {
        return Article(
            id: link ?? title.orEmpty,
            title: title.orEmpty,
            description: description.orEmpty,
            link: link.orEmpty,
            author: author.orEmpty,
            imageUrl: enclosure?.attributes?.url,
            date: pubDate ?? Date.distantPast,
            isRead: false
        )
    }
}

extension RSSFeedItem: RealmObjectMappable {
    func toObject() -> ArticleObject {
        let articleObject = ArticleObject()
        articleObject.id = link ?? title.orEmpty
        articleObject.title = title.orEmpty
        articleObject.descr = description.orEmpty
        articleObject.link = link.orEmpty
        articleObject.author = author.orEmpty
        articleObject.imageURL = enclosure?.attributes?.url
        articleObject.date = pubDate ?? Date.distantPast
        articleObject.isRead = false
        
        return articleObject
    }
}

extension Collection where Iterator.Element: RSSFeedItemMappable {
    func toArticles() -> [Article] {
        map { $0.toArticle() }
    }
}
