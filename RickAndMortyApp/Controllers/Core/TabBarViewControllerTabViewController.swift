//
//  TabBarViewController.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 17/12/23.
//

import UIKit

/// Main app class for general navigation
final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        setUpTabs()
    }
    
    /// Set up tabs options
    private func setUpTabs() {
        
        let charactersVC = CharacterViewController()
        charactersVC.title = "Characters"
        charactersVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let locationVC = LocationViewController()
        locationVC.title = "Characters"
        locationVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let episodesVC = EpisodeViewController()
        episodesVC.title = "Episodes"
        episodesVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let settingsVC = SettingsViewController()
        settingsVC.title = "Settings"
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let charactersNavController = UINavigationController(rootViewController: charactersVC)
        charactersNavController.tabBarItem = UITabBarItem(title: "Characters",
                                                          image: UIImage(systemName: "person.3.sequence"),
                                                          tag: 1)
        let locationNavController = UINavigationController(rootViewController: locationVC)
        locationNavController.tabBarItem = UITabBarItem(title: "Locations",
                                                        image: UIImage(systemName: "location"),
                                                        tag: 2)
        let episodesNavController = UINavigationController(rootViewController: episodesVC)
        episodesNavController.tabBarItem = UITabBarItem(title: "Episodes",
                                                        image: UIImage(systemName: "film.stack"),
                                                        tag: 3)
        let settingsNavController = UINavigationController(rootViewController: settingsVC)
        settingsNavController.tabBarItem = UITabBarItem(title: "Settings",
                                                        image: UIImage(systemName: "gearshape"),
                                                        tag: 4)
        
        for nav in  [charactersNavController, locationNavController, episodesNavController, settingsNavController] {
            nav.navigationBar.prefersLargeTitles = true
            
        }
        
        setViewControllers([charactersNavController, locationNavController, episodesNavController, settingsNavController], animated: false)
    }


}

