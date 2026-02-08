//
//  UpdateReadingStatusUseCase.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 8.02.26.
//

import Foundation

protocol IUpdateReadingStatusUseCase {
    func start(articleID: String)
}

final class UpdateReadingStatusUseCase: IUpdateReadingStatusUseCase {
    private let repository: INewsRepository
    
    init(repository: INewsRepository) {
        self.repository = repository
    }
    
    func start(articleID: String) {
        repository.updateReadingStatus(articleID: articleID)
    }
}
