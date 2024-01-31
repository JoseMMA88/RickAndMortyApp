//
//  ImageLoader.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 3/1/24.
//

import Foundation

final class ImageLoader {
    
    // MARK: - Singleton
    
    static let shared = ImageLoader()
    
    // MARK: - Properties
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Functions
    
    /// Get Image content with URL
    /// - Parameters:
    ///   - url: Source URL
    ///   - completion: callback
    public func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data))
            return
        }
            
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self = self else { return }
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let value = data as NSData
            self.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }.resume()
    }
}
