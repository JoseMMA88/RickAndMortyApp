//
//  APICacheManager.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 31/1/24.
//

import Foundation

/// Manages in memory session scoped API caches
final class APICacheManager {
    
    // MARK: - Singleton
    
    static let shared = APICacheManager()
    
    // MARK: - Properties
    
    private var cacheDictionary: [APIEndPoint: NSCache<NSString, NSData>] = [:]
    
    // MARK: - Init
    
    init() {
        setUpCache()
    }
    
    // MARK: - Functions
    
    public func cacheResponse(for endPoint: APIEndPoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endPoint],
              let targetUrlString = url?.absoluteString as? NSString else {
            return nil
        }
        
        return targetCache.object(forKey: targetUrlString) as? Data
    }
    
    public func setCache(for endPoint: APIEndPoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endPoint],
              let targetUrlString = url?.absoluteString as? NSString else {
            return
        }
        
        targetCache.setObject(data as NSData, forKey: targetUrlString)
    }
    
    private func setUpCache() {
        APIEndPoint.allCases.forEach({ endPoint in
            cacheDictionary[endPoint] = NSCache<NSString, NSData>()
        })
    }
    
}
