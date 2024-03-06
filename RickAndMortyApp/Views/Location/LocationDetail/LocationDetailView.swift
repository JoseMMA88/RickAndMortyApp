//
//  LocationDetailView.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 6/3/24.
//

import UIKit

protocol LocationDetailViewDelegate: AnyObject {
    func didSelectCharacter(_ detailView: LocationDetailView, character: Character)
}

final class LocationDetailView: UIView {
    
    // MARK: - Properties
    
    private var viewModel: LocationDetailViewViewModel? {
        didSet {
            spinner.stopAnimating()
            collectionView?.reloadData()
            collectionView?.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.collectionView?.alpha = 1
            }
        }
    }
    
    public weak var delegate: LocationDetailViewDelegate?
    
    private var collectionView: UICollectionView?
    
    // MARK: - Views
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        return spinner
    }()

    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubview(collectionView)
        addSubview(spinner)
        addConstraints()
        spinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Functions
    
    private func addConstraints() {
        guard let collectionView = collectionView else { return }
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
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
        collectionView.register(EpisodeInfoCollectionViewCell.self,
                                forCellWithReuseIdentifier: EpisodeInfoCollectionViewCell.identifier)
        collectionView.register(CharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: CharacterCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        
        return collectionView
    }
    
    private func createCollectionLayoutSection(for section: Int) -> NSCollectionLayoutSection {
        guard let sectionType = viewModel?.cellViewModels[section] else { fatalError("No viewModel") }
        
        switch sectionType {
        case .information:
            return createCollectionLayoutForEpisodeInfoSection()
        case .characters:
            return createCollectionLayoutForCharacterSection()
        }
    }
    
    private func createCollectionLayoutForEpisodeInfoSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                            heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                     leading: 10,
                                                     bottom: 10,
                                                     trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .absolute(80)),
                                                     subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }
    
    private func createCollectionLayoutForCharacterSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                                                            heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5,
                                                     leading: 10,
                                                     bottom: 5,
                                                     trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                       heightDimension: .absolute(260)),
                                                     subitems: [item, item])
        
        return NSCollectionLayoutSection(group: group)
    }
    
    public func configure(with viewModel: LocationDetailViewViewModel) {
        self.viewModel = viewModel
    }

}

// MARK: - UICollectionViewDelegate and UICollectionViewDataSource

extension LocationDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = viewModel?.cellViewModels[section] else { return 0 }
        
        switch sectionType {
        case .information(let viewModel):
            return viewModel.count
        case .characters(let characters):
            return characters.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = viewModel?.cellViewModels[indexPath.section] else { fatalError("No viewModel") }
        
        switch sectionType {
        case .information(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeInfoCollectionViewCell.identifier,
                                                                for: indexPath) as? EpisodeInfoCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(model: viewModel[indexPath.row])
            
            return cell
        case .characters(let characters):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifier,
                                                                for: indexPath) as? CharacterCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: characters[indexPath.row])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { fatalError("No viewModel") }
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let sectionType = viewModel.cellViewModels[indexPath.section]
        
        switch sectionType {
        case .characters:
            guard let character = viewModel.character(at: indexPath.row) else { return }
            delegate?.didSelectCharacter(self, character: character)
        default:
            break
        }
        
    }
}

