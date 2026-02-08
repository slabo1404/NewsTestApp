//
//  ArticleObject+DomainMappable.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 7.02.26.
//

extension ArticleObject: DomainMappable {
    func toDomain() -> Article {
        .init(id: id,
              title: title,
              description: descr,
              link: link,
              author: author,
              imageUrl: imageURL,
              date: date,
              isRead: isRead
        )
    }
}
