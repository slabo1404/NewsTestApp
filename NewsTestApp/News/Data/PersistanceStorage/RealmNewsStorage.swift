//
//  RealmNewsStorage.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 7.02.26.
//

import UIKit
import Foundation
import RealmSwift
import FeedKit

final class RealmNewsStorage: INewsStorage {
    private let newsStorageQueue = DispatchQueue(label: "NewsStorageQueue", qos: .utility)
    
    func fetchNews() async -> [Article] {
        await withCheckedContinuation { continuation in
            newsStorageQueue.async {
                do {
                    let realm = try Realm()
                    let articles = realm.objects(ArticleObject.self)
                        .sorted(byKeyPath: "date", ascending: false)
                        .array()
                        .toDomain()
                    
                    continuation.resume(returning: articles)
                } catch {
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    @discardableResult
    func saveNews(_ articles: [ArticleObject]) -> [Article] {
        var articlesToReturn: [Article] = []
        
        newsStorageQueue.sync {
            do {
                let realm = try Realm()
                
                let ids = articles.map { $0.id }
                let oldObjects = realm.objects(ArticleObject.self)
                let objectsToDelete = oldObjects.filter("NOT id in %@", ids)
                let oldReadObjectsDict = Dictionary(uniqueKeysWithValues: oldObjects.map {($0.id, $0.isRead)})
                
                let newArticles = articles.map { article in
                    if let isRead = oldReadObjectsDict[article.id], isRead {
                        article.isRead = true
                    }
                    
                    return article
                }
                
                try realm.write {
                    if !objectsToDelete.isEmpty {
                        realm.delete(objectsToDelete)
                    }
                    
                    realm.add(newArticles, update: oldObjects.isEmpty ? .all : .modified)
                    articlesToReturn = newArticles.toDomain().sorted(by: >)
                }
                
            } catch {
                debugPrint("\(String(describing: self)) has unresolved error: \(error)")
            }
        }
        
        return articlesToReturn
    }
    
    func setReadingStatus(articleID: String) {
        newsStorageQueue.async {
            do {
                let realm = try Realm()
                
                let articleObject = realm.objects(ArticleObject.self).filter { $0.id == articleID }.first
                
                guard let articleObject else { return }
                
                try realm.write {
                    articleObject.isRead = true
                }
                
            } catch {
                debugPrint("\(String(describing: self)) has unresolved error: \(error)")
            }
        }
    }
}
