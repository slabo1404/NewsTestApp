//
//  Untitled.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 6.02.26.
//

import Foundation

enum RSSFeedParserError: Error {
    case invalidURL
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Неверный url"
        case .noData:
            "Данные отсутствуют"
        }
    }
}
