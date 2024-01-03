//
//  CharacterDetailViewController.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 2/1/24.
//

import UIKit


/// Controller to show character extra information
final class CharacterDetailViewController: UIViewController {
    
    private let viewModel: CharacterDetailViewViewModel?
    
    init(viewModel: CharacterDetailViewViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel?.title
    }
    

}
