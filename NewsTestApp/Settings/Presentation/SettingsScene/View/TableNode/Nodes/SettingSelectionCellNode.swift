//
//  SettingSelectionCellNode.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 9.02.26.
//

import AsyncDisplayKit

final class SettingSelectionCellNode: ASCellNode {
    // MARK: - Nodes
    
    private let titleNode = ASTextNode()
    private let valueNode = ASTextNode()
    
    // MARK: - Init
    
    init(title: String, value: String) {
        super.init()
        
        backgroundColor = UIColor.white
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 80)
        neverShowPlaceholders = true
        
        titleNode.isLayerBacked = true
        titleNode.maximumNumberOfLines = 1
        titleNode.style.flexGrow = 1
        titleNode.truncationMode = .byTruncatingTail
        titleNode.attributedText = NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 14, weight: .medium)
            ])
        
        valueNode.isLayerBacked = true
        valueNode.style.flexShrink = 1
        valueNode.maximumNumberOfLines = 1
        valueNode.attributedText = NSAttributedString(
            string: value,
            attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 14, weight: .medium)
            ])
        
        addSubnode(titleNode)
        addSubnode(valueNode)
    }
    
    // MARK: - Layout
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentStack = ASStackLayoutSpec.horizontal()
        contentStack.spacing = 8
        contentStack.justifyContent = .start
        contentStack.alignItems = .center
        contentStack.children = [titleNode, valueNode]
        
        let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return ASInsetLayoutSpec(insets: insets, child: contentStack)
    }
}
