//
//  APIService.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 17/12/23.
//

import Foundation

/// APIService object to get Rick and Morty data
final class APIService {
    
    // MARK: - Enums
    
    /// Service error types
    enum ServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    // MARK: - Propeties
    
    /// Singleton
    static let share = APIService()
    
    private let cacheManager = APICacheManager()
    
    // MARK: - Init
    
    private init() {}
    
    
    // MARK: - Functions
    
    /// Send API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: Expected model
    ///   - completion: Callback with data or error
    public func execute<T: Codable>(_ request: APIRequest,
                                    expecting type: T.Type,
                                    completion: @escaping (Result<T, Error>) -> Void) {
        
        if let cacheData = cacheManager.cacheResponse(for: request.endPoint,
                                                      url: request.url) {
            do {
                let result = try JSONDecoder().decode(type.self, from: cacheData)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            return
        }
        
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(ServiceError.failedToCreateRequest))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let self = self else { return }
            guard let data = data, error == nil else {
                completion(.failure(error ?? ServiceError.failedToGetData))
                return
            }
            
            // Decode data
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                self.cacheManager.setCache(for: request.endPoint,
                                      url: request.url,
                                      data: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        
        }.resume()
        
    }
    
    // MARK: - Private functions
    
    private func request(from apiRequest: APIRequest) -> URLRequest? {
        guard let url = apiRequest.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.httpMethod
        
        
        return request
    }
}
