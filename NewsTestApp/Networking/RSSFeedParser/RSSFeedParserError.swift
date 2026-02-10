//
//  Untitled.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 6.02.26.
//

import Foundation

enum RSSFeedParserError: Error {
    case emptyUrls
    case invalidURL
    case noFetchedData
    
    var errorDescription: String? {
        switch self {
        case .emptyUrls:
            "Выберите хотя бы один источник"
        case .invalidURL:
            "Неверный url"
        case .noFetchedData:
            "Ошибка загрузки данных"
        }
    }
}
