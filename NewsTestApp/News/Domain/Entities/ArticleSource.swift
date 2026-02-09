//
//  ArticleSource.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 6.02.26.
//

import Foundation

enum ArticleSource: String, CaseIterable {
    case vedomosti = "Ведомости"
    case rbc = "Рбк"
    
    var url: String {
        switch self {
        case .vedomosti:
            return "https://www.vedomosti.ru/rss/news.xml"
        case .rbc:
            return "https://rssexport.rbc.ru/rbcnews/news/30/full.rss"
        }
    }
}
