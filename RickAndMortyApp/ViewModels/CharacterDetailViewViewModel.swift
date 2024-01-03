//
//  CharacterDetailViewViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 2/1/24.
//

import Foundation

final class CharacterDetailViewViewModel {
    
    //MARK: - Properties
    
    private let character: Character
    
    //MARK: - Init
    
    init(character: Character) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
}
