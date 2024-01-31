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
        title = "Episode"
        view.backgroundColor = .systemCyan
    }

}
