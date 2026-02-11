//
//  SharedPreferences.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 9.02.26.
//

import Foundation

struct SharedPreferences {
    enum Keys: String {
        case isFirstAppLaunch = "isFirstAppLaunch"
        case selectedSources = "selectedSources"
        case timerInterval = "timerInterval"
        case usеImageCache = "usеImageCache"
        case showDescription = "showDescription"
    }
    
    @UserDefault(key: Keys.isFirstAppLaunch.rawValue, defaultValue: true)
    static var isFirstAppLaunch: Bool
    
    @UserDefault(key: Keys.selectedSources.rawValue, defaultValue: []
)
    static var selectedSources: [String]
    
    @UserDefault(key: Keys.timerInterval.rawValue, defaultValue: 0)
    static var timerInterval: Int
    
    @UserDefault(key: Keys.usеImageCache.rawValue, defaultValue: true)
    static var usеImageCache: Bool
    
    @UserDefault(key: Keys.showDescription.rawValue, defaultValue: false)
    static var showDescription: Bool
}
