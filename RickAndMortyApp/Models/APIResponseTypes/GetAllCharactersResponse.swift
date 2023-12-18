//
//  GetAllCharactersResponse.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 18/12/23.
//

import Foundation

struct GetAllCharactersResponse: Codable {
    let info: Info
    let results: [Character]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
