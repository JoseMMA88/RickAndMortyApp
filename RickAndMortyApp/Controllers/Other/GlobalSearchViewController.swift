//
//  GlobalSearchViewController.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 2/2/24.
//

import UIKit

/// Configurable controller to search
final class GlobalSearchViewController: UIViewController {
    
    // MARK: - Properties
    
    struct Config {
        
        enum `Type` {
            case character
            case episode
            case location
        }
        
        let type: `Type`
    }
    
    private let config: Config
    
    // MARK: - Init
    
    init(config: Config) {
        self.config = config
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
    }

}
