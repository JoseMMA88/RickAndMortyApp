//
//  EpisodeDetailViewController.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 30/1/24.
//

import UIKit

/// ViewController to show single episode details
final class EpisodeDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: EpisodeDetailViewViewModel
    private let detailView = EpisodeDetailView()
    
    // MARK: - Initializer
    
    init(url: URL) {
        self.viewModel = .init(endPointUrl: url)
        
        super.init(nibName: nil, bundle:  nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        setUpConstraints()
        title = viewModel.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapShareButton))
        
        viewModel.delegate = self
        detailView.delegate = self
        viewModel.fetchEpisode()
    }
    
    // MARK: - Functions
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func didTapShareButton() {
        // TODO: Share character info
    }

}

// MARK: - EpisodeDetailViewViewModelDelegate

extension EpisodeDetailViewController: EpisodeDetailViewViewModelDelegate {
    func didFetchEpisodeDetails() {
        detailView.configure(with: viewModel)
    }
}

// MARK: - EpisodeDetailViewDelegate

extension EpisodeDetailViewController: EpisodeDetailViewDelegate {
    func didSelectCharacter(_ detailView: EpisodeDetailView, character: Character) {
        let vc = CharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
