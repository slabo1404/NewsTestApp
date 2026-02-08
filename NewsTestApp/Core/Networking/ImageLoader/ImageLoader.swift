//
//  ImageLoader.swift
//  NewsTestApp
//
//  Created by Вячеслав Болбат on 8.02.26.
//

import Foundation
import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    
    private init() {}
    
    func clearCache() async {
        await ImageCache.shared.clear()
    }
    
    func loadImage(urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        
        if let image = await ImageCache.shared.get(key: urlString) {
            return image
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else { return nil }
            
            await ImageCache.shared.set(image: image, key: urlString)
            
            return image
        } catch {
            return nil
        }
    }
}

fileprivate actor ImageCache {
    static let shared = ImageCache()
    
    private init() {}
    
    private var cache = NSCache<NSString, UIImage>()
    
    func get(key: String) async -> UIImage? {
        cache.object(forKey: NSString(string: key))
    }
    
    func set(image: UIImage, key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
    
    func clear() {
        cache.removeAllObjects()
    }
}
