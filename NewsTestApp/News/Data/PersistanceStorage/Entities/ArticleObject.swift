//
//  ArticleObject.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 7.02.26.
//

import Foundation
import RealmSwift

final class ArticleObject: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var title: String = ""
    @Persisted var descr: String = ""
    @Persisted var link: String = ""
    @Persisted var author: String = ""
    @Persisted var imageURL: String? = nil
    @Persisted var date: Date = Date()
    @Persisted var isRead: Bool = false
}
