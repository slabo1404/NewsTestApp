//
//  SettingsViewModel.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 9.02.26.
//

import Combine
import Foundation

protocol SettingsViewModelInput {
    func updateTimerInterval(value: Int)
    func updateUseImageCache(value: Bool)
    func updateShowDescription(value: Bool)
}

protocol SettingsViewModelOutput {
    var settingsPublisher: AnyPublisher<[AppSetting], Never> { get }
    var defaultTimeIntervals: [String] { get set }
}

protocol ISettingsViewModel: SettingsViewModelInput, SettingsViewModelOutput {}

final class SettingsViewModel: ObservableObject, ISettingsViewModel {
    @Published private var settings: [AppSetting] = [
        
        .init(title: "Выберите новостной источник",
              type: .newsSource,
              action: .select,
              value: 0),
        .init(
            title: "Выберите интервал обновления",
            type: .timerIntervar, action: .select,
            value: SharedPreferences.timerInterval
        ),
        .init(title: "Кэшировать изображения в ленте",
              type: .useImageCache,
              action: .switcher,
              value: SharedPreferences.isUsеImageCache ? 1 : 0
        ),
        .init(title: "Показывать описание новости",
              type: .showDescription,
              action: .switcher,
              value: SharedPreferences.isShowDescription ? 1 : 0
        )
    ]
    
    // Inputs
    
    var settingsPublisher: AnyPublisher<[AppSetting], Never>  {
        $settings.eraseToAnyPublisher()
    }
    
    // Outputs
    
    var defaultTimeIntervals = ["15", "30", "60", "120", "Выключить"]
    
    func updateTimerInterval(value: Int) {
        guard let index = settings.firstIndex(where: { $0.type == .timerIntervar }) else { return }
        
        SharedPreferences.timerInterval = value
        updateSetting(on: index, with: value)
    }
    
    func updateUseImageCache(value: Bool) {
        guard let index = settings.firstIndex(where: { $0.type == .useImageCache }) else { return }
        
        SharedPreferences.isUsеImageCache = value
        updateSetting(on: index, with: value ? 1 : 0)
    }
    
    func updateShowDescription(value: Bool) {
        guard let index = settings.firstIndex(where: { $0.type == .showDescription }) else { return }
        
        SharedPreferences.isShowDescription = value
        updateSetting(on: index, with: value ? 1 : 0)
    }
    
    private func updateSetting(on index: Int, with value: Int) {
        var setting = settings[index]
        setting.value = value
        
        settings[index] = setting
    }
}
