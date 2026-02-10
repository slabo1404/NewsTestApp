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
    
    func loadImage(urlString: String, useCache: Bool) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        
        if useCache, let image = await ImageCache.shared.get(key: urlString) {
            return image
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else { return nil }
            
            if useCache {
                await ImageCache.shared.set(image: image, key: urlString)
            }
            
            return image
        } catch {
            return nil
        }
    }
}

fileprivate actor ImageCache {
    static let shared = ImageCache()
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()
        
    private var diskPath: URL = {
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ImageCache")
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }()
    
    private func getFileURL(for key: String) -> URL {
        let path = Data(key.utf8).base64EncodedString().replacingOccurrences(of: "/", with: "_")
        return diskPath.appendingPathComponent(path)
    }
    
    func get(key: String) async -> UIImage? {
        let nsKey = NSString(string: key)
        
        if let cached = cache.object(forKey: nsKey) {
            return cached
        }
        
        let fileURL = getFileURL(for: key)
        
        if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
            cache.setObject(image, forKey: nsKey)
            print("get key = \(key)")
            return image
        }
        
        return nil
    }
    
    func set(image: UIImage, key: String) {
        cache.setObject(image, forKey: NSString(string: key))
        
        let fileURL = getFileURL(for: key)
        
        if let data = image.jpegData(compressionQuality: 0.6) {
            try? data.write(to: fileURL)
        }
    }
    
    func clear() {
        cache.removeAllObjects()
        try? FileManager.default.removeItem(at: diskPath)
        try? FileManager.default.createDirectory(at: diskPath, withIntermediateDirectories: true)
    }
}
