//
//  ArticleSource.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 6.02.26.
//

import Foundation

enum ArticleSource: String, CaseIterable {
    case vedomosti = "vedomosti"
    case rbc = "rbc"
    
    static func detectSource(from link: String) -> ArticleSource {
        if link.contains(ArticleSource.vedomosti.rawValue) {
            return .vedomosti
        } else if link.contains(ArticleSource.rbc.rawValue) {
            return .rbc
        }
        
        return .rbc
    }
    
    static var actualURLs: [String] {
        ArticleSource.allCases.map { $0.urlString }
    }
    
    var urlString: String {
        switch self {
        case .vedomosti:
            "https://www.vedomosti.ru/rss/news.xml"
        case .rbc:
            "https://rssexport.rbc.ru/rbcnews/news/30/full.rss"
        }
    }
    
    var title: String {
        switch self {
        case .vedomosti:
            "Ведомости"
        case .rbc:
            "РБК"
        }
    }
}
