//
//  Collection+Mappable.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 7.02.26.
//

import Foundation
import RealmSwift

extension Collection where Iterator.Element: RealmObjectMappable {
    func toObjects() -> [Element.RealmObject] {
        map { $0.toObject() }
    }
}

extension Collection where Iterator.Element: DomainMappable {
    func toDomain() -> [Element.DomainModel] {
        map { $0.toDomain() }
    }
}
