//
//  CharacterDetailViewViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 2/1/24.
//

import UIKit

final class CharacterDetailViewViewModel {
    
    //MARK: - Properties
    
    //MARK: Sections
    enum SectionType {
        case photo(viewModel: CharacterPhotoViewCellViewModel)
        case information(viewModels: [CharacterInfoViewCellViewModel])
        case episodes(viewModels: [CharacterEpisodeViewCellViewModel])
    }
    
    /// Sections array
    public var sections: [SectionType] = []
    
    /// Character Model to present informations
    private let character: Character
    
    /// View title
    public var title: String {
        character.name.uppercased()
    }
    
    //MARK: - Init
    
    init(character: Character) {
        self.character = character
        setUpSections()
    }
    
    //MARK: - Functions
    
    private func setUpSections() {
        guard let characterImageURL = URL(string: character.image) else { return }
        
        sections = [
            .photo(viewModel: .init(imageURL: characterImageURL)),
            .information(viewModels: [.init(value: character.status.rawValue, title: "Status"),
                                      .init(value: character.gender.rawValue, title: "Gender"),
                                      .init(value: character.type, title: "Type"),
                                      .init(value: character.species, title: "Species"),
                                      .init(value: character.origin.name, title: "Origin"),
                                      .init(value: character.location.name, title: "Location"),
                                      .init(value: character.created, title: "Created"),
                                      .init(value: "\(character.episode.count)", title: "Total Episodes")]),
            .episodes(viewModels: character.episode.compactMap({ episode in
                guard let episodeURL = URL(string: episode) else { return nil }
                return CharacterEpisodeViewCellViewModel(episodeDataURL: episodeURL)
            }))
        ]
    }
    
    public func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                             heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                     leading: 0,
                                                     bottom: 10,
                                                     trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                        heightDimension: .fractionalHeight(0.5)),
                                                     subitems: [item])
        let collecionLayoutSection =  NSCollectionLayoutSection(group: group)
        
        return collecionLayoutSection
    }
    
    public func createInfoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                                             heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                     leading: 2,
                                                     bottom: 2,
                                                     trailing: 2)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                          heightDimension: .absolute(150)),
                                                       subitems: [item, item])
        let collecionLayoutSection =  NSCollectionLayoutSection(group: group)
        
        return collecionLayoutSection
    }
    
    public func createEpisodesSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                             heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                     leading: 5,
                                                     bottom: 10,
                                                     trailing: 5)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                                                                          heightDimension: .absolute(150)),
                                                       subitems: [item])
        let collecionLayoutSection =  NSCollectionLayoutSection(group: group)
        collecionLayoutSection.orthogonalScrollingBehavior = .groupPaging
        return collecionLayoutSection
    }
}
