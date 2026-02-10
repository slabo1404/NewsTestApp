//
//  SettingSwitcherCellNode.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 9.02.26.
//

import AsyncDisplayKit

final class SettingSwitcherCellNode: ASCellNode {
    // MARK: - Nodes
    
    private let titleNode = ASTextNode()
    private let switchNode = SwitcherNode()
    
    private var isOn: Bool
    
    var changeValue: ((Bool) -> Void)?
    
    // MARK: - Init

    init(title: String, isOn: Bool) {
        self.isOn = isOn
        super.init()
        
        backgroundColor = UIColor.white
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 80)
        neverShowPlaceholders = true
        
        titleNode.isLayerBacked = true
        titleNode.style.flexShrink = 1
        titleNode.style.flexGrow = 1
        titleNode.maximumNumberOfLines = 1
        titleNode.truncationMode = .byTruncatingTail
        titleNode.attributedText = NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 14, weight: .medium)
            ])
        
        switchNode.style.preferredSize = CGSize(width: 47, height: 31)
        
        addSubnode(titleNode)
        addSubnode(switchNode)
    }
    
    // MARK: - Lifecycle
    
    override func didLoad() {
        super.didLoad()

        switchNode.switcher.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        switchNode.switcher.isOn = isOn
    }
    
    // MARK: - Events
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        changeValue?(sender.isOn)
    }
    
    // MARK: - Layout
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {        
        let contentStack = ASStackLayoutSpec.horizontal()
        contentStack.spacing = 8
        contentStack.justifyContent = .start
        contentStack.alignItems = .center
        contentStack.children = [titleNode, switchNode]
        
        let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 24)
        return ASInsetLayoutSpec(insets: insets, child: contentStack)
    }
}
