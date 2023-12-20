//
//  CharacterListViewViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 20/12/23.
//

import UIKit

protocol CharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
}

final class CharacterListViewViewModel: NSObject {
    
    public weak var delegate: CharacterListViewViewModelDelegate?
    
    private var characters: [Character] = [] {
        didSet {
            for character in characters {
                let viewModel = CharacterCollectionViewCell.Model(name: character.name,
                                                                  imageURL: URL(string: character.image),
                                                                  status: character.status)
                cellViewModel.append(viewModel)
            }
        }
    }
    
    private var cellViewModel: [CharacterCollectionViewCell.Model] = []
    
    public func fetchCharacters() {
        let request = APIRequest(endPoint: .character)
        
        APIService.share.execute(request, expecting: GetAllCharactersResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let responseModel):
                self.characters = responseModel.results
                DispatchQueue.main.async {
                    self.delegate?.didLoadInitialCharacters()
                }
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
        return cellViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifier,
                                                      for: indexPath) as? CharacterCollectionViewCell
        else {
            fatalError("Unsopported cell")
        }
        
        cell.configure(with: cellViewModel[indexPath.row])

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
