//
//  UserDefault.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 9.02.26.
//

import Foundation

@propertyWrapper
final class UserDefault<Value> {
    let key: String
    let defaultValue: Value
    
    init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: Value {
        get {
            UserDefaults.standard.value(forKey: key) as? Value ?? defaultValue
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}
