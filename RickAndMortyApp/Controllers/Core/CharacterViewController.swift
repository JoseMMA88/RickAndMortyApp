//
//  CharacterViewController.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 17/12/23.
//

import UIKit

/// Controller to show and search for characters
final class CharacterViewController: UIViewController {
    
    //MARK: - Properties
    
    private let characterListView = CharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        characterListView.delegate = self
        
        setUpView()
    }
    
    //MARK: - Functions
    
    private func setUpView() {
        view.addSubview(characterListView)
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

//MARK: - CharacterListViewDelegate

extension CharacterViewController: CharacterListViewDelegate {
    
    func characterListView(_ characteListView: CharacterListView, didSelectCharacter character: Character) {
        // Open detail controller for character
        let viewModel = CharacterDetailViewViewModel(character: character)
        let detailVC = CharacterDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
