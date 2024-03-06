//
//  LocationViewViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 22/2/24.
//

import Foundation

protocol LocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class LocationViewViewModel {
    
    // MARK: - Properties
    weak var delegate: LocationViewViewModelDelegate?
    
    private var locations: [Location] = [] {
        didSet {
            for location in locations {
                let cellViewModel = LocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    private var apiInfo: GetAllLocationsResponse.Info?
    
    public private(set) var cellViewModels: [LocationTableViewCellViewModel] = []
    
    private var hasMoreResults: Bool {
        return false
    }
    
    // MARK: - Initializers
    
    init() {
        
    }
    
    // MARK: - Functions
    
    public func location(at index: Int) -> Location? {
        guard index < locations.count else { return nil }
        return locations[index]
    }
    
    public func fetchLocations() {
        let request = APIRequest(endPoint: .location)
        
        APIService.share.execute(request,
                                 expecting: GetAllLocationsResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.apiInfo = model.info
                self.locations = model.results
                DispatchQueue.main.async {
                    self.delegate?.didFetchInitialLocations()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
