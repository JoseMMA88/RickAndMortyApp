//
//  SettingsOption.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 12/2/24.
//

import UIKit

enum SettingsOption: CaseIterable {
    
    // MARK: - Cases
    
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    
    // MARK: - Properties
    
    var targetUrl: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https://josemalagon.es/contact/")
        case .terms:
            return URL(string: "https://josemalagon.es")
        case .privacy:
            return URL(string: "https://josemalagon.es")
        case .apiReference:
            return URL(string: "https://rickandmortyapi.com")
        case .viewSeries:
            return URL(string: "https://www.hbomax.com")
        case .viewCode:
            return URL(string: "https://github.com/JoseMMA88/RickAndMortyApp")
        }
    }
    
    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .terms:
            return "Terms of Service"
        case .privacy:
            return "Privacy Policy"
        case .apiReference:
            return "API Reference"
        case .viewSeries:
            return "View Series at HBO"
        case .viewCode:
            return "View App Code"
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
    
    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return .systemYellow
        case .contactUs:
            return .systemBlue
        case .terms:
            return .systemBrown
        case .privacy:
            return .systemMint
        case .apiReference:
            return .systemCyan
        case .viewSeries:
            return .systemGray
        case .viewCode:
            return .systemGreen
        }
    }
}
