//
//  EpisodeDetailViewViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 31/1/24.
//

import Foundation

final class EpisodeDetailViewViewModel {
    
    // MARK: - Properties
    
    private let endPointUrl: URL?
    
    // MARK: - Init
    
    init(endPointUrl: URL?) {
        self.endPointUrl = endPointUrl
        fetchEpisode()
    }
    
    // MARK: - Functions
    
    public func fetchEpisode() {
        guard let url = self.endPointUrl,
              let request = APIRequest(url: url) else {
            return
        }
        
        APIService.share.execute(request,
                                 expecting: Episode.self) { result in
            switch result {
            case .success(let model):
                print(String(describing: model))
            case .failure(let failure):
                break
            }
        }
    }
    
}
