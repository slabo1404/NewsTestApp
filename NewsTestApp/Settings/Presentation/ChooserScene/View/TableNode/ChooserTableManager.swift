//
//  ChooserTableManager.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 9.02.26.
//

import AsyncDisplayKit

protocol ChooserTableManagerDelegate: AnyObject {
    func updateSelected(_ values: [String])
}

final class ChooserTableManager: NSObject {
    private var values: [String]
    private var selectedValues: [String]
    private var allowMultipleSelection: Bool

    weak var delegate: ChooserTableManagerDelegate?

    init(values: [String], selectedValues: [String], allowMultipleSelection: Bool) {
        self.values = values
        self.selectedValues = selectedValues
        self.allowMultipleSelection = allowMultipleSelection
    }
}

// MARK: - ASTableDataSource

extension ChooserTableManager: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        values.count
    }

    func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let value = values[indexPath.row]
        let isSelected = selectedValues.contains(value)

        return {
            return ChooserCellNode(title: value, showCheckmark: isSelected)
        }
    }
}

// MARK: - ASTableDelegate

extension ChooserTableManager: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        
        let value = values[indexPath.row]
        
        if allowMultipleSelection {
            if let index = selectedValues.firstIndex(where: { $0 == value }) {
                selectedValues.remove(at: index)
            } else {
                selectedValues.append(value)
            }
        } else {
            selectedValues = [value]
        }
        
        delegate?.updateSelected(selectedValues)
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
