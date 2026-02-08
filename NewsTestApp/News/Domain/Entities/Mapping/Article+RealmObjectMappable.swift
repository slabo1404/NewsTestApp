//
//  Article+RealmObjectMappable.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 8.02.26.
//

import Foundation

extension Article: RealmObjectMappable {
    func toObject() -> ArticleObject {
        let articleObject = ArticleObject()
        articleObject.id = id
        articleObject.title = title
        articleObject.descr = description
        articleObject.link = link
        articleObject.author = author
        articleObject.imageURL = imageUrl
        articleObject.date = date
        articleObject.isRead = isRead

        return articleObject
    }
}
