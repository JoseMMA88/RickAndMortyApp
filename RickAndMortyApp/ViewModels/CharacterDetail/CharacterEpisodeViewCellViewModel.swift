//
//  CharacterEpisodeViewCellViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 14/1/24.
//

import Foundation

final class CharacterEpisodeViewCellViewModel {
    
    //MARK: - Properties
    
    private let episodeDataURL: URL?
    
    //MARK: - Init
    
    init(episodeDataURL: URL) {
        self.episodeDataURL = episodeDataURL
    }
}
