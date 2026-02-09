//
//  AppSetting.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 9.02.26.
//

struct AppSetting {
    let title: String
    let type: SettingType
    let action: InteractionType
    var value: Int

    enum SettingType: String {
        case newsSource
        case timerIntervar
        case useImageCache
        case showDescription
    }

    enum InteractionType: String {
        case select
        case switcher
    }
}
