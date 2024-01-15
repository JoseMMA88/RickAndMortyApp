//
//  CharacterDetailView.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 2/1/24.
//

import UIKit

/// View for single character information
final class CharacterDetailView: UIView {
    
    //MARK: - Properties
    
    public var collectionView: UICollectionView?
    private let viewModel: CharacterDetailViewViewModel
    
    //MARK: - Views
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        return spinner
    }()

    //MARK: - Initializer
    
    init(frame: CGRect, viewModel: CharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubview(collectionView)
        addSubview(spinner)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    //MARK: - Function
    
    private func addConstraints() {
        guard let collectionView = collectionView else { return }
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createCollectionLayoutSection(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(CharacterPhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: CharacterPhotoCollectionViewCell.identifier)
        collectionView.register(CharacterInfoCollectionViewCell.self,
                                forCellWithReuseIdentifier: CharacterInfoCollectionViewCell.identifier)
        collectionView.register(CharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: CharacterEpisodeCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }
    
    private func createCollectionLayoutSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let sectionTypes = viewModel.sections
        switch sectionTypes[sectionIndex] {
        case .photo:
            return viewModel.createPhotoSectionLayout()
        case .information:
            return viewModel.createInfoSectionLayout()
        case .episodes:
            return viewModel.createEpisodesSectionLayout()
        }
    }
}
