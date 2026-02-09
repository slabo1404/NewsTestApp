//
//  DomainMappable.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 7.02.26.
//

import Foundation

protocol DomainMappable {
    associatedtype DomainModel
    
    func toDomain() -> DomainModel
}
