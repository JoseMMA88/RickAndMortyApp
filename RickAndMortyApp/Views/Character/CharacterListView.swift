//
//  CharacterListView.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 20/12/23.
//

import UIKit

protocol CharacterListViewDelegate: AnyObject {
    func characterListView(_ characteListView: CharacterListView,
                           didSelectCharacter character: Character)
}

/// View thats show collection fo charactes
final class CharacterListView: UIView {
    
    // MARK: - Properties
    
    public weak var delegate: CharacterListViewDelegate?
    
    private let viewModel = CharacterListViewViewModel()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCollectionViewCell.identifier)
        collectionView.register(FooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: FooterLoadingCollectionReusableView.identifier)
        
        return collectionView
    }()
    
    // MARK: - Init
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        addSubview(spinner)
        
        addConstraints()
        setUpCollectionView()
        
        spinner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchCharacters()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Functions
    
    private func addConstraints() {
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
    
    private func setUpCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
    
}

// MARK: - CharacterLisViewViewModelDelegate

extension CharacterListView: CharacterListViewViewModelDelegate {
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: newIndexPaths)
        }
    }
    
    func didSelectCharacter(_ character: Character) {
        delegate?.characterListView(self, didSelectCharacter: character)
    }
    
    func didLoadInitialCharacters() {
        spinner.stopAnimating()
        collectionView.reloadData()
        collectionView.isHidden = false
        
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
}
