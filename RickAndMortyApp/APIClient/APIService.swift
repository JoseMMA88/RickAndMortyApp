//
//  APIService.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 17/12/23.
//

import Foundation

/// APIService object to get Rick and Morty data
final class APIService {
    /// Singleton
    static let share = APIService()
     
    private init() {}
    
    /// Service error types
    enum ServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Send API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: Expected model
    ///   - completion: Callback with data or error
    public func execute<T: Codable>(_ request: APIRequest,
                                    expecting type: T.Type,
                                    completion: @escaping (Result<T, Error>) -> Void) {
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(ServiceError.failedToCreateRequest))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? ServiceError.failedToGetData))
                return
            }
            
            // Docede data
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                print(String(describing: data))
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        
        }.resume()
        
    }
    
    //MARK: - Private functions
    
    private func request(from apiRequest: APIRequest) -> URLRequest? {
        guard let url = apiRequest.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.httpMethod
        
        
        return request
    }
}
