//
//  LocationDetailViewViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 6/3/24.
//

import Foundation

// MARK: - Protocol

protocol LocationDetailViewViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
}

final class LocationDetailViewViewModel {
    
    // MARK: - Properties
    
    // MARK: Sections
    
    enum SectionType {
        case information(viewModel: [EpisodeInfoCollectionViewCell.Model])
        case characters(viewModel: [CharacterCollectionViewCell.Model])
    }
    
    public weak var delegate: LocationDetailViewViewModelDelegate?
    
    private let endPointUrl: URL?
    
    private var location: Location?
    
    private var dataTuple: (location: Location, characters: [Character])? {
        didSet {
            createCellViewModel()
            delegate?.didFetchLocationDetails()
        }
    }
    
    public private(set) var cellViewModels: [SectionType] = []
    
    /// View title
    public var title: String {
        location?.name.uppercased() ?? "LOCATION"
    }
    
    // MARK: - Init
    
    init(endPointUrl: URL?) {
        self.endPointUrl = endPointUrl
    }
    
    // MARK: - Functions
    
    /// Fetch backing location model
    public func fetchLocation() {
        guard let url = self.endPointUrl,
              let request = APIRequest(url: url) else {
            return
        }
        
        APIService.share.execute(request,
                                 expecting: Location.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let locationModel):
                self.location = locationModel
                self.fetchRelatedCharacters(location: locationModel)
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
        let location = dataTuple.location
        let characters = dataTuple.characters
        let charactersViewModel: [CharacterCollectionViewCell.Model] = characters.compactMap({
            return CharacterCollectionViewCell.Model.init(name: $0.name,
                                                          imageURL: URL(string: $0.image),
                                                          status: $0.status)
        })
        
        var createdString = location.created
        if let date = CharacterInfoViewCellViewModel.dateFormatter.date(from: location.created) {
            createdString = CharacterInfoViewCellViewModel.displayDateFormatter.string(from: date)
        }
        
        cellViewModels = [.information(viewModel: [.init(title: "Location Name", value: location.name),
                                                   .init(title: "Type", value: location.type),
                                                   .init(title: "Dimension", value: location.dimension),
                                                   .init(title: "Created", value: createdString)]),
                          .characters(viewModel: charactersViewModel)]
    }
    
    private func fetchRelatedCharacters(location: Location) {
        let requests: [APIRequest] = location.residents.compactMap({
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
            self.dataTuple = (location: location, characters: characters)
        }
        
    }
    
}

