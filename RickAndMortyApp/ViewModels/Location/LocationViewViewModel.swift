//
//  LocationViewViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 22/2/24.
//

import Foundation

final class LocationViewViewModel {
    
    // MARK: - Properties
    
    private var locations: [Location] = []
    
    private var cellViewModel: [String] = []
    
    private var hasMoreResults: Bool {
        return false
    }
    
    // MARK: - Initializers
    
    init() {
        
    }
    
    // MARK: - Functions
    
    public func fetchLocations() {
        let request = APIRequest(endPoint: .location)
        
        APIService.share.execute(request,
                                 expecting: String.self) { result in
            switch result {
            case .success(let model):
                break
            case .failure(let error):
                break
            }
        }
    }
}
