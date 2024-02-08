//
//  EpisodeDetailViewViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 31/1/24.
//

import Foundation

// MARK: - Protocol

protocol EpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class EpisodeDetailViewViewModel {
    
    // MARK: - Properties
    
    // MARK: Sections
    
    enum SectionType {
        case information(viewModel: [EpisodeInfoCollectionViewCell.Model])
        case characters(viewModel: [CharacterCollectionViewCell.Model])
    }
    
    public weak var delegate: EpisodeDetailViewViewModelDelegate?
    
    private let endPointUrl: URL?
    
    private var episode: Episode?
    
    private var dataTuple: (episode: Episode, characters: [Character])? {
        didSet {
            createCellViewModel()
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    public private(set) var cellViewModels: [SectionType] = []
    
    /// View title
    public var title: String {
        episode?.name.uppercased() ?? "EPISODE"
    }
    
    // MARK: - Init
    
    init(endPointUrl: URL?) {
        self.endPointUrl = endPointUrl
    }
    
    // MARK: - Functions
    
    /// Fetch backing episode model
    public func fetchEpisode() {
        guard let url = self.endPointUrl,
              let request = APIRequest(url: url) else {
            return
        }
        
        APIService.share.execute(request,
                                 expecting: Episode.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let episodeModel):
                self.episode = episodeModel
                self.fetchRelatedCharacters(episode: episodeModel)
            case .failure:
                break
            }
        }
    }
    
    public func character(at index: Int) -> Character? {
        guard let dataTuple = dataTuple else { return nil }
        
        return dataTuple.characters[index]
    }
    
    private func createCellViewModel() {
        guard let dataTuple = dataTuple else { return }
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        let charactersViewModel: [CharacterCollectionViewCell.Model] = characters.compactMap({
            return CharacterCollectionViewCell.Model.init(name: $0.name,
                                                          imageURL: URL(string: $0.image),
                                                          status: $0.status)
        })
        
        var createdString = episode.created
        if let date = CharacterInfoViewCellViewModel.dateFormatter.date(from: episode.created) {
            createdString = CharacterInfoViewCellViewModel.displayDateFormatter.string(from: date)
        }
        
        cellViewModels = [.information(viewModel: [.init(title: "Episode Name", value: episode.name),
                                                   .init(title: "Air Date", value: episode.air_date),
                                                   .init(title: "Episode", value: episode.episode),
                                                   .init(title: "Created", value: createdString)]),
                          .characters(viewModel: charactersViewModel)]
    }
    
    private func fetchRelatedCharacters(episode: Episode) {
        let requests: [APIRequest] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return APIRequest(url: $0)
        })
        
        // Parallel requests
        let group = DispatchGroup()
        var characters: [Character] = []
        for request in requests {
            group.enter()
            APIService.share.execute(request,
                                     expecting: Character.self) { result in
                // last line to execute when the program exit this scoope
                defer {
                    group.leave()
                }
                
                switch result {
                case .success(let characterModel):
                    characters.append(characterModel)
                case .failure:
                    break
                 }
            }
        }
        
        // Notified when all requests end
        group.notify(queue:  .main) {
            self.dataTuple = (episode: episode, characters: characters)
        }
        
    }
    
}
