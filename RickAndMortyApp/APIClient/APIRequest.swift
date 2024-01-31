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
    
    public let endPoint: APIEndPoint
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
    
    /// Attempt to create URL:
    /// - Parameter url: URL to parse
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl + "/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endPointString = components[0] // Endpoint
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let endpoint = APIEndPoint(rawValue: endPointString) {
                    self.init(endPoint: endpoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endPointString = components[0]
                let queryItemsString = components[1]
                // value=name&value=name
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    
                    return URLQueryItem(name: parts[0], value: parts[1])
                })
                
                if let endPoint = APIEndPoint(rawValue: endPointString) {
                    self.init(endPoint: endPoint, queryParameters: queryItems)
                    return
                }
            }
        }
        
        return nil
    }
    
}

