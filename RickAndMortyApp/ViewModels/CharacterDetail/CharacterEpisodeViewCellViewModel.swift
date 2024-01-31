//
//  CharacterEpisodeViewCellViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 14/1/24.
//

import Foundation

protocol EpisodeDataRender {
    var episode: String { get }
    var name: String { get }
    var air_date: String { get }
}

final class CharacterEpisodeViewCellViewModel {
    
    // MARK: - Properties
    
    private let episodeDataURL: URL?
    private var isFetching = false
    private var dataBlock: ((EpisodeDataRender) -> Void)?
    private var episode: Episode? {
        didSet {
            guard let model = episode else { return }
            dataBlock?(model)
        }
    }
    
    // MARK: - Init
    
    init(episodeDataURL: URL) {
        self.episodeDataURL = episodeDataURL
    }
    
    // MARK: - Functions
    
    public func registerForData(_ block: @escaping (EpisodeDataRender) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchEpisodeInfo() {
        guard !isFetching else {
            if let model = episode {
                dataBlock?(model)
            }
            return
        }
        
        guard let url = self.episodeDataURL,
              let request = APIRequest(url: url) else { return }
        
        isFetching = true
        APIService.share.execute(request, expecting: Episode.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.episode = model
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
