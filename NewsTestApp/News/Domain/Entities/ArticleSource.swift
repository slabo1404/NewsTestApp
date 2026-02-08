//
//  ArticleSource.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 6.02.26.
//

import Foundation

enum ArticleSource: String, CaseIterable {
    case vedomosti = "https://www.vedomosti.ru/rss/news.xml"
    case rbc = "https://rssexport.rbc.ru/rbcnews/news/30/full.rss"
    
    static var actualURLs: [String] {
        ArticleSource.allCases.map { $0.rawValue }
    }
}
