//
//  GetAllLocationsResponse.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 29/2/24.
//

import Foundation

struct GetAllLocationsResponse: Codable {
    let info: Info
    let results: [Location]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
