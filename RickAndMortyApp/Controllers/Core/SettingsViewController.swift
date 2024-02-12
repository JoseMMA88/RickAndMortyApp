//
//  SettingsViewController.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 17/12/23.
//

import StoreKit
import SafariServices
import SwiftUI
import UIKit

/// Controller to show various app settings
final class SettingsViewController: UIViewController {
    // MARK: - Properties
    
    private var settingsSwiftUIController: UIHostingController<SettingsView>?

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Settings"
        addSwiftUIController()
    }
    
    // MARK: - Functions
    
    private func addSwiftUIController() {
        let settingsSwiftUIController = UIHostingController(
            rootView: SettingsView(
                viewModel: SettingsViewViewModel(
                    cellViewModels: SettingsOption.allCases.compactMap({
                        return .init(type: $0) { [weak self] option in
                            guard let self = self else { return }
                            self.handleAction(option: option)
                        }
                    })
                )
            )
        )
        
        addChild(settingsSwiftUIController)
        settingsSwiftUIController.didMove(toParent: self)
        
        view.addSubview(settingsSwiftUIController.view)
        settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsSwiftUIController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.settingsSwiftUIController = settingsSwiftUIController
    }
    
    private func handleAction(option: SettingsOption) {
        guard Thread.current.isMainThread else { return }
        
        if let url = option.targetUrl {
            // Open website
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        } else if option == .rateApp {
            // Show rating prompt
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene')
            }
        }
    }

}
