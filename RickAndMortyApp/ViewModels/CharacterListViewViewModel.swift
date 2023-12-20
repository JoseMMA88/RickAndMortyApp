//
//  CharacterListViewViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 20/12/23.
//

import UIKit

final class CharacterListViewViewModel: NSObject {
    
    func fetchCharacters() {
        let request = APIRequest(endPoint: .character)
        
        APIService.share.execute(request, expecting: GetAllCharactersResponse.self) { result in
            switch result {
            case .success(let model):
                print(String(describing: model))
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

//MARK: - CollectionViewDelegate

extension CharacterListViewViewModel: UICollectionViewDelegate {
    
}

//MARK: - CollectionViewDataSource

extension CharacterListViewViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifier,
                                                      for: indexPath) as? CharacterCollectionViewCell
        else {
            fatalError("Unsopported cell")
        }
        
        let model = CharacterCollectionViewCell.Model(name: "Rick",
                                                      imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"),
                                                      status: .alive)
        cell.configure(with: model)

        return cell
    }
    
}

//MARK: - CollectionViewDelegateFlowLayout

extension CharacterListViewViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
}
