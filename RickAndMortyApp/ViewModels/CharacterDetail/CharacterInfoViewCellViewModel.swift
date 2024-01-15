//
//  CharacterInfoViewCellViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 14/1/24.
//

import Foundation

final class CharacterInfoViewCellViewModel {
    
    //MARK: - Properties
    
    public let value: String
    public let title: String
    
    //MARK: - Init
    
    init(value: String, title: String) {
        self.value = value
        self.title = title
    }
}
