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
    private let cache = ImageCache.shared
    private init() {}
    
    func getCachedImage(for url: String) -> UIImage? {
        cache.getFromMemory(key: url)
    }
    
    func clearCache() async {
        await ImageCache.shared.clear()
    }
    
    func loadImage(urlString: String, useCache: Bool) async -> UIImage? {
        if useCache, let cached = await cache.get(key: urlString) {
            return cached
        }
        
        guard let url = URL(string: urlString) else { return nil }
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = useCache ? .returnCacheDataElseLoad : .reloadIgnoringLocalCacheData
        
        do {
            let (data, _) = try await URLSession(configuration: config).data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            
            if useCache {
                await cache.set(image: image, key: urlString)
            }
            return image
        } catch {
            return nil
        }
    }
}

fileprivate final class ImageCache {
    static let shared = ImageCache()
    private init() {}

    private let cache = NSCache<NSString, UIImage>()
    
    private let diskActor = ImageDiskActor()

    func getFromMemory(key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func get(key: String) async -> UIImage? {
        if let cached = getFromMemory(key: key) {
            return cached
        }
        
        if let diskImage = await diskActor.loadFromDisk(key: key) {
            cache.setObject(diskImage, forKey: key as NSString)
            return diskImage
        }
        
        return nil
    }

    func set(image: UIImage, key: String) async {
        cache.setObject(image, forKey: key as NSString)
        await diskActor.saveToDisk(image: image, key: key)
    }

    func clear() async {
        cache.removeAllObjects()
        await diskActor.clearDisk()
    }
}

fileprivate actor ImageDiskActor {
    private var diskPath: URL = {
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ImageCache")
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }()

    func loadFromDisk(key: String) -> UIImage? {
        let fileURL = getFileURL(for: key)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }

    func saveToDisk(image: UIImage, key: String) {
        let fileURL = getFileURL(for: key)
        if let data = image.jpegData(compressionQuality: 0.6) {
            try? data.write(to: fileURL)
        }
    }

    func clearDisk() {
        try? FileManager.default.removeItem(at: diskPath)
        try? FileManager.default.createDirectory(at: diskPath, withIntermediateDirectories: true)
    }

    private func getFileURL(for key: String) -> URL {
        let path = Data(key.utf8).base64EncodedString().replacingOccurrences(of: "/", with: "_")
        return diskPath.appendingPathComponent(path)
    }
}
