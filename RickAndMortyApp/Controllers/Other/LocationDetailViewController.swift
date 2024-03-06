//
//  LocationDetailViewController.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 6/3/24.
//

import UIKit

class LocationDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let detailView: LocationDetailView = LocationDetailView()
    private let viewModel: LocationDetailViewViewModel
    
    // MARK: - Initializers
    
    init(location: Location) {
        self.viewModel = .init(endPointUrl: URL(string: location.url))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(detailView)
        setUpConstraints()
        title = viewModel.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapShareButton))
        
        viewModel.delegate = self
        detailView.delegate = self
        viewModel.fetchLocation()
    }
    
    // MARK: - Fuctions
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        ])
    }
    
    @objc private func didTapShareButton() {
        //TODO: Share location info
    }

}

// MARK: - LocationDetailViewViewModelDelegate

extension LocationDetailViewController: LocationDetailViewViewModelDelegate {
    func didFetchLocationDetails() {
        detailView.configure(with: viewModel)
    }
}

// MARK: - LocationDetailViewDelegate

extension LocationDetailViewController: LocationDetailViewDelegate {
    func didSelectCharacter(_ detailView: LocationDetailView, character: Character) {
        let vc = CharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
