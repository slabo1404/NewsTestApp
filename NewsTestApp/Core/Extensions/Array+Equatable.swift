//
//  Array+Equatable.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 8.02.26.
//

import UIKit

extension Array where Element: Equatable {
    public func fetchDifferences(from array: [Element]) -> (insertions: [IndexPath], removals: [IndexPath]) {
        let changes = self.difference(from: array)
        
        let insertedIndexPaths = changes.insertions.compactMap { change -> IndexPath? in
            guard case let .insert(offset, _, _) = change else {
                return nil
            }
            
            return IndexPath(row: offset, section: 0)
        }
        
        let removedIndexPaths = changes.removals.compactMap { change -> IndexPath? in
            guard case let .remove(offset, _, _) = change else {
                return nil
            }
            
            return IndexPath(row: offset, section: 0)
        }
        
        return (insertions: insertedIndexPaths, removals: removedIndexPaths)
    }
}
