//
//  GetAllEpisodesResponse.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 31/1/24.
//

import Foundation

struct GetAllEpisodesResponse: Codable {
    let info: Info
    let results: [Episode]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
