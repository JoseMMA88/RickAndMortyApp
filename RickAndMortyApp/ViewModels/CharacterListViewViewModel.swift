//
//  CharacterListViewViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 20/12/23.
//

import UIKit

protocol CharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    func didSelectCharacter(_ character: Character)
    
}

/// Handle all Character List View Logic
final class CharacterListViewViewModel: NSObject {
    
    public weak var delegate: CharacterListViewViewModelDelegate?
    
    private var isLoadingMoreCharacters: Bool = false
    
    private var characters: [Character] = [] {
        didSet {
            for character in characters {
                let viewModel = CharacterCollectionViewCell.Model(name: character.name,
                                                                  imageURL: URL(string: character.image),
                                                                  status: character.status)
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [CharacterCollectionViewCell.Model] = []
    
    private var apiInfo: GetAllCharactersResponse.Info? = nil
 
    private var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    /// Fetch initial set of characters
    public func fetchCharacters() {
        let request = APIRequest(endPoint: .character)
        
        APIService.share.execute(request, expecting: GetAllCharactersResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let responseModel):
                self.characters = responseModel.results
                self.apiInfo = responseModel.info
                
                DispatchQueue.main.async {
                    self.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// Paginate if additional characters is needed
    public func fetchAdditionalCharacter(url: URL) {
        guard !isLoadingMoreCharacters else { return }
        
        isLoadingMoreCharacters = true
        guard let request = APIRequest(url: url) else {
            isLoadingMoreCharacters = false
            return
        }
        
        APIService.share.execute(request, expecting: GetAllCharactersResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let responseModel):
                self.apiInfo = responseModel.info
                
                let originalCount = self.characters.count
                let newCount = responseModel.results.count
                let total = originalCount + newCount
                let startingIndex = total - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                characters.append(contentsOf: responseModel.results)
                
                DispatchQueue.main.async {
                    self.delegate?.didLoadMoreCharacters(with: indexPathsToAdd)
                    self.isLoadingMoreCharacters = false
                }
            case .failure(let error):
                print(String(describing: error))
                self.isLoadingMoreCharacters = false
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
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifier,
                                                      for: indexPath) as? CharacterCollectionViewCell
        else {
            fatalError("Unsopported cell")
        }
        
        cell.configure(with: cellViewModels[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didSelectCharacter(characters[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: FooterLoadingCollectionReusableView.identifier,
                                                                           for: indexPath) as? FooterLoadingCollectionReusableView else {
            fatalError("Unsuported")
        }
        
        footer.startAnimating()
        
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        
        return CGSize(width: collectionView.frame.width,
                      height: 100)
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

//MARK: - UIScrolViewDelegate

extension CharacterListViewViewModel: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            guard let self = self else { return }
            
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120){
                self.fetchAdditionalCharacter(url: url)
            }
            t.invalidate()
        }
    }
}
