//
//  LocationTableViewCellViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 29/2/24.
//

import Foundation


struct LocationTableViewCellViewModel: Hashable, Equatable {
    
    // MARK: - Properties
    
    private let location: Location
    
    public var name: String {
        return location.name
    }
    
    public var type: String {
        return "Type: " + location.type
    }
    
    public var dimension: String {
        return location.dimension
    }
    
    // MARK: - Initializers
    
    init(location: Location) {
        self.location = location
    }
    
    // MARK: - Functions
    
    static func == (lhs: LocationTableViewCellViewModel, rhs: LocationTableViewCellViewModel) -> Bool {
        lhs.location.id == rhs.location.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(location.id)
        hasher.combine(dimension)
        hasher.combine(type)
    }
}
