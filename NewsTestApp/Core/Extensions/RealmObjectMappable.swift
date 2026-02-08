//
//  RealmObjectMappable.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 7.02.26.
//

import Foundation
import RealmSwift

protocol RealmObjectMappable {
    associatedtype RealmObject: Object
    
    func toObject() -> RealmObject
}

extension Results where Element: Object {
    public func array() -> [Element] {
        compactMap { $0 }.filter { !$0.isInvalidated }
    }
}
