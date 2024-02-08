//
//  EpisodeListViewViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 31/1/24.
//

import UIKit

protocol EpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
    func didSelectEpisode(_ Episode: Episode)
}

/// Handle all Episode List View Logic
final class EpisodeListViewViewModel: NSObject {
    
    public weak var delegate: EpisodeListViewViewModelDelegate?
    
    private var isLoadingMoreEpisodes: Bool = false
    
    private let borderColors: [UIColor] = [.systemRed,
                                           .systemOrange,
                                           .systemGreen,
                                           .systemCyan,
                                           .systemBrown,
                                           .systemBlue,
                                           .systemPurple,
                                           .systemRed]
    
    private var episodes: [Episode] = [] {
        didSet {
            for episode in episodes {
                if let url = URL(string: episode.url) {
                    let viewModel = CharacterEpisodeViewCellViewModel(episodeDataURL: url,
                                                                      borderColor: borderColors.randomElement() ?? .systemGreen)
                    
                    if !cellViewModels.contains(viewModel) {
                        cellViewModels.append(viewModel)
                    }
                }
            }
            
        }
    }
    
    private var cellViewModels: [CharacterEpisodeViewCellViewModel] = []
    
    private var apiInfo: GetAllEpisodesResponse.Info? = nil
 
    private var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    /// Fetch initial set of episodes
    public func fetchEpisodes() {
        let request = APIRequest(endPoint: .episode)
        
        APIService.share.execute(request, expecting: GetAllEpisodesResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let responseModel):
                self.episodes = responseModel.results
                self.apiInfo = responseModel.info
                
                DispatchQueue.main.async {
                    self.delegate?.didLoadInitialEpisodes()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// Paginate if additional epsiodes is needed
    public func fetchAdditionalEpisodes(url: URL) {
        guard !isLoadingMoreEpisodes else { return }
        
        isLoadingMoreEpisodes = true
        guard let request = APIRequest(url: url) else {
            isLoadingMoreEpisodes = false
            return
        }
        
        APIService.share.execute(request, expecting: GetAllEpisodesResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let responseModel):
                self.apiInfo = responseModel.info
                
                let originalCount = self.episodes.count
                let newCount = responseModel.results.count
                let total = originalCount + newCount
                let startingIndex = total - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                episodes.append(contentsOf: responseModel.results)
                
                DispatchQueue.main.async {
                    self.delegate?.didLoadMoreEpisodes(with: indexPathsToAdd)
                    self.isLoadingMoreEpisodes = false
                }
            case .failure(let error):
                print(String(describing: error))
                self.isLoadingMoreEpisodes = false
            }
        }
    }
}

// MARK: - CollectionViewDelegate

extension EpisodeListViewViewModel: UICollectionViewDelegate {
    
}

// MARK: - CollectionViewDataSource

extension EpisodeListViewViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterEpisodeCollectionViewCell.identifier,
                                                      for: indexPath) as? CharacterEpisodeCollectionViewCell
        else {
            fatalError("Unsopported cell")
        }
        
        cell.configure(with: cellViewModels[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didSelectEpisode(episodes[indexPath.row])
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

// MARK: - CollectionViewDelegateFlowLayout

extension EpisodeListViewViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = (bounds.width - 20)
        return CGSize(width: width, height: 110)
    }
}

// MARK: - UIScrollViewDelegate

extension EpisodeListViewViewModel: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreEpisodes,
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
                self.fetchAdditionalEpisodes(url: url)
            }
            t.invalidate()
        }
    }
}

