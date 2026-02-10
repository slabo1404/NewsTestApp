//
//  NewsTableManager.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 6.02.26.
//

import AsyncDisplayKit

protocol NewsTableManagerDelegate: AnyObject {
    func didSelect(_ article: Article)
}

final class NewsTableManager: NSObject {
    private var articles = [Article]()
    private var showDescription: Bool = false
    private var useImageCache = true
    
    weak var delegate: NewsTableManagerDelegate?
    
    func updateArticles(_ articles: [Article], showDescription: Bool, useImageCache: Bool) {
        self.articles = articles
        self.showDescription = showDescription
        self.useImageCache = useImageCache
    }
    
    func updateShowDesription(_ showDescription: Bool) {
        self.showDescription = showDescription
    }
    
    func updateUseImagecache(_ useImageCache: Bool) {
        self.useImageCache = useImageCache
    }
}

// MARK: - ASTableDataSource

extension NewsTableManager: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let article = articles[indexPath.row]
        let showDescription = showDescription
        let useImageCache = useImageCache
        
        return {
            return NewsCellNode(
                article: article,
                showDescription: showDescription,
                useImageCache: useImageCache
            )
        }
    }
}

// MARK: - ASTableDelegate

extension NewsTableManager: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        
        delegate?.didSelect(article)
    }
    
    func tableNode(_ tableNode: ASTableNode, didHighlightRowAt indexPath: IndexPath) {
        let node = tableNode.nodeForRow(at: indexPath)
        node?.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
    }
    
    func tableNode(_ tableNode: ASTableNode, didUnhighlightRowAt indexPath: IndexPath) {
        let node = tableNode.nodeForRow(at: indexPath)
        node?.backgroundColor = UIColor.white
    }
}
