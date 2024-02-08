//
//  EpisodeViewController.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 17/12/23.
//

import UIKit

/// Controller to show and search for episodes
final class EpisodeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let episodeListView = EpisodeListView()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Episodes"
        
        episodeListView.delegate = self
        
        setUpView()
        addSearchButton()
    }
    
    // MARK: - Functions
    
    private func setUpView() {
        view.addSubview(episodeListView)
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(didTapSearchButton))
    }
    
    @objc
    private func didTapSearchButton() {
        
    }

}

// MARK: - EpisodeListViewDelegate

extension EpisodeViewController: EpisodeListViewDelegate {
    
    func episodeListView(_ episodeListView: EpisodeListView, didSelectEpisode episode: Episode) {
        // Open detail controller for episode
        if let url = URL(string: episode.url) {
            let detailVC = EpisodeDetailViewController(url: url)
            detailVC.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

}
