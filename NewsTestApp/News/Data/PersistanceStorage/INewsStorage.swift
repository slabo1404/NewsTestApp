//
//  INewsStorage.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 7.02.26.
//

import Foundation
import FeedKit

protocol INewsStorage {
    func fetchNews() async -> [Article]
    @discardableResult
    func saveNews(_ articles: [ArticleObject]) -> [Article]
    func setReadingStatus(articleID: String)
}
