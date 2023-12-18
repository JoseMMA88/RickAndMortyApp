//
//  APIRequest.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 17/12/23.
//

import Foundation


/// Single API Call
final class APIRequest {
    
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    private let endPoint: APIEndPoint
    private let pathComponents: [String]
    private let queryParameters: [URLQueryItem]
    
    /// URL with parameters in String format
    private var stringURL: String {
        var string = "\(Constants.baseUrl)/\(endPoint.rawValue)"
        
        if pathComponents.isEmpty == false {
            for pathComponent in pathComponents {
                string += "/\(pathComponent)"
            }
        }
        
        if queryParameters.isEmpty == false {
            string += "/?"
            let queryString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += queryString
        }
        
        return string
    }
    
    public var url: URL? {
        return URL(string: stringURL)
    }
    
    public let httpMethod = "GET"
    
    /// Inicializer
    /// - Parameters:
    ///   - endPoint: API EndPoint
    ///   - pathComponents: Models
    ///   - queryParameters: Parameters for filters
    public init(endPoint: APIEndPoint,
         pathComponents: [String] = [],
         queryParameters: [URLQueryItem] = []) {
        self.endPoint = endPoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
}

