//
//  CharacterDetailViewController.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 2/1/24.
//

import UIKit

/// Controller to show character extra information
final class CharacterDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: CharacterDetailViewViewModel
    
    private let detailView: CharacterDetailView
    
    //MARK: - Initializers
    
    init(viewModel: CharacterDetailViewViewModel){
        self.viewModel = viewModel
        self.detailView = CharacterDetailView(frame: .zero,
                                              viewModel: viewModel)
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapShareButton))
        setUpView()
    
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
    }
    
    //MARK: - Functions
    
    private func setUpView() {
        view.addSubview(detailView)
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func didTapShareButton() {
        // TODO: Share character info
    }

}

//MARK: - UICollectionViewDelegate and UICollectionViewDataSource

extension CharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .photo:
            return 1
        case .information(let viewModels):
            return viewModels.count
        case .episodes(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        
        switch sectionType {
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterPhotoCollectionViewCell.identifier,
                                                                for: indexPath) as? CharacterPhotoCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel)
            
            return cell
        case .information(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterInfoCollectionViewCell.identifier,
                                                                for: indexPath) as? CharacterInfoCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModels[indexPath.row])
            
            return cell
        case .episodes(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterEpisodeCollectionViewCell.identifier,
                                                                for: indexPath) as? CharacterEpisodeCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: viewModels[indexPath.row])
            
            return cell
        }
    }
}
