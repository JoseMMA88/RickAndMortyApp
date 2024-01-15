//
//  CharacterPhotoViewCellViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 14/1/24.
//

import Foundation

final class CharacterPhotoViewCellViewModel {
    
    //MARK: - Properties
    
    private let imageURL: URL?
    
    //MARK: - Init
    
    init(imageURL: URL) {
        self.imageURL = imageURL
    }
    
    //MARK: - Functions
    
    public func fetchImage(completion: @escaping(Result<Data, Error>) -> Void) {
        guard let url = imageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        ImageLoader.shared.downloadImage(url, completion: completion)
    }
}
