//
//  LocationViewController.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 17/12/23.
//

import UIKit

/// Controller to show and search locations
final class LocationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let primaryView = LocationView()
    
    private let viewModel = LocationViewViewModel()

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(primaryView)
        view.backgroundColor = .systemBackground
        title = "Location"
        addSearchButton()
        addContraints()
        primaryView.delegate = self
        viewModel.delegate = self
        viewModel.fetchLocations()
    }
    
    // MARK: - Functions
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(didTapSearchButton))
    }
    
    @objc
    private func didTapSearchButton() {
        
    }
    
    private func addContraints() {
        NSLayoutConstraint.activate([
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

// MARK: - LocationViewViewModelDelegate

extension LocationViewController: LocationViewViewModelDelegate {
    func didFetchInitialLocations() {
        primaryView.configure(with: viewModel)
    }
}


// MARK: - LocationViewDelegate

extension LocationViewController: LocationViewDelegate {
    func locationView(_: LocationView, didSelect location: Location) {
        let vcDetail = LocationDetailViewController(location: location)
        vcDetail.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vcDetail, animated: true)
    }
}
