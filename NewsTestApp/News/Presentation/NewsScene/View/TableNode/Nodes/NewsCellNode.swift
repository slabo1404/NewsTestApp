//
//  NewsCellNode.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 6.02.26.
//

import AsyncDisplayKit
import UIKit

final class NewsCellNode: ASCellNode {
    // MARK: - Nodes
    
    private let imageNode = ASImageNode()
    private let isReadStatusImageNode = ASImageNode()
    private let titleNode = ASTextNode()
    private let descriptionNode = ASTextNode()
    private let sourceNode = ASTextNode()
    
    // MARK: - Private properties
    
    private let article: Article
    private let displayMode: DisplayMode
    
    init(article: Article, displayMode: DisplayMode) {
        self.article = article
        self.displayMode = displayMode
        super.init()
        
        backgroundColor = UIColor.white
        separatorInset = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
        selectionStyle = .none
        
        imageNode.style.preferredSize = CGSize(width: 55, height: 34)
        imageNode.cornerRadius = 4
        imageNode.cornerRoundingType = .precomposited
        imageNode.isLayerBacked = true
        imageNode.image = UIImage(named: "news_default")
        
        isReadStatusImageNode.style.preferredSize = CGSize(width: 16, height: 16)
        isReadStatusImageNode.isLayerBacked = true
        isReadStatusImageNode.image = UIImage(named: "accepted")
        
        titleNode.isLayerBacked = true
        titleNode.maximumNumberOfLines = 0
        titleNode.truncationMode = .byTruncatingTail
        titleNode.attributedText = NSAttributedString(
            string: article.title,
            attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
            ])
        
        descriptionNode.isLayerBacked = true
        descriptionNode.maximumNumberOfLines = 0
        descriptionNode.truncationMode = .byTruncatingTail
        descriptionNode.attributedText = NSAttributedString(
            string: article.description,
            attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 12)
            ])
        
        sourceNode.isLayerBacked = true
        sourceNode.maximumNumberOfLines = 1
        sourceNode.style.flexGrow = 1
        sourceNode.attributedText = NSAttributedString(
            string: article.source.title,
            attributes: [
                .foregroundColor: UIColor.gray.withAlphaComponent(0.7),
                .font: UIFont.systemFont(ofSize: 10)
            ])
        
        addSubnode(imageNode)
        addSubnode(isReadStatusImageNode)
        addSubnode(titleNode)
        addSubnode(descriptionNode)
        addSubnode(sourceNode)
    }
    
    // MARK: - Overriden
    
    override func didLoad() {
        super.didLoad()
        
        // MARK: - Fetch image
    }
    
    // MARK: - Layout
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let sourceStatusStack = ASStackLayoutSpec.horizontal()
        sourceStatusStack.children = article.isRead
        ? [sourceNode, isReadStatusImageNode]
        : [sourceNode]
        
        let titlesStack = ASStackLayoutSpec.vertical()
        titlesStack.spacing = 4
        titlesStack.justifyContent = .start
        titlesStack.children = displayMode == .expanded && !article.description.isEmpty
        ? [titleNode, descriptionNode]
        : [titleNode]
      
        let contentVerticalStack = ASStackLayoutSpec.vertical()
        contentVerticalStack.spacing = 8
        contentVerticalStack.style.flexGrow = 1
        contentVerticalStack.style.flexShrink = 1
        contentVerticalStack.justifyContent = .start
        contentVerticalStack.alignItems = .stretch
        contentVerticalStack.children = [titlesStack, sourceStatusStack]
        
        let contentStack = ASStackLayoutSpec.horizontal()
        contentStack.spacing = 8
        contentStack.justifyContent = .start
        contentStack.alignItems = .center
        contentStack.children = [imageNode, contentVerticalStack]
        
        let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return ASInsetLayoutSpec(insets: insets, child: contentStack)
    }
}
