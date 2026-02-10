//
//  ChooserCellNode.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 9.02.26.
//

import AsyncDisplayKit

final class ChooserCellNode: ASCellNode {
    // MARK: - Nodes

    private let titleNode = ASTextNode()
    private let checkmarkImageNode = ASImageNode()

    // MARK: - Private properties

    private let showCheckmark: Bool

    // MARK: - Inits

    init(title: String, showCheckmark: Bool) {
        self.showCheckmark = showCheckmark
        super.init()

        backgroundColor = UIColor.white
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
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
        
        addSubnode(titleNode)

        if showCheckmark {
            checkmarkImageNode.isLayerBacked = true
            checkmarkImageNode.style.preferredSize = CGSize(width: 16, height: 16)
            checkmarkImageNode.image = UIImage(named: "accepted")
            addSubnode(checkmarkImageNode)
        }
    }

    // MARK: - Layout

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentSpec = ASStackLayoutSpec.horizontal()
        contentSpec.spacing = 8

        if showCheckmark {
            contentSpec.children = [titleNode, checkmarkImageNode]
        } else {
            contentSpec.children = [titleNode]
        }

        let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return ASInsetLayoutSpec(insets: insets, child: contentSpec)
    }
}
