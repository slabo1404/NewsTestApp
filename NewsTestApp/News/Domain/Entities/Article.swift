//
//  Article.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 6.02.26.
//

import Foundation

struct Article: Identifiable, Sendable {
    let id: String
    let title: String
    let description: String
    let link: String
    let author: String
    let imageUrl: String?
    let date: Date
    var isRead: Bool
}

extension Article: Comparable {
    static func < (lhs: Article, rhs: Article) -> Bool {
        lhs.date < rhs.date
    }
}
