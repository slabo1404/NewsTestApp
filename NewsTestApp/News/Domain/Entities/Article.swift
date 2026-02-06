//
//  Article.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 6.02.26.
//

import Foundation

struct Article: Identifiable {
    let id: String
    let title: String
    let description: String
    let link: String
    var source: ArticleSource = .rbc
    var isRead: Bool = false
    
    init(id: String, title: String, description: String, link: String) {
        self.id = id
        self.title = title
        self.description = description
        self.link = link
        self.source = ArticleSource.detectSource(from: link)
        self.isRead = Bool.random()
    }
}
