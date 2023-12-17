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
    
    /// Send API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - completion: Callback with data or error
    public func execute(_ request: APIRequest, completion: @escaping () -> Void) {
        
    }
}
