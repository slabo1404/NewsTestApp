//
//  INewsRepository.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 7.02.26.
//

protocol INewsRepository {
    func fetchNews(urls: [String]) async throws -> AsyncThrowingStream<[Article], Error>
    func updateReadingStatus(articleID: String)
}
