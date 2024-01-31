//
//  CharacterInfoViewCellViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 14/1/24.
//

import Foundation
import UIKit

final class CharacterInfoViewCellViewModel {
    
    // MARK: - Properties
    
    /// static because date formatter initilization is expensive
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        // 2017-11-04T18:48:46.250Z
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = .current
        
        return formatter
    }()
    
    static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter
    }()
    
    private let type: `Type`
    private let value: String
    
    public var title: String {
        return type.titleString
    }
    
    public var displayValue: String {
        if value.isEmpty {
            return "None"
        }
        
        if type == .created,
           let date = Self.dateFormatter.date(from: value) {
            return Self.displayDateFormatter.string(from: date)
        }
        
        return value
    }
    
    public var iconImage: UIImage? {
        return type.iconImage
    }
    
    public var tintColor: UIColor {
        return type.tintColor
    }
    
    enum `Type`: String {
        case status
        case gender
        case type
        case species
        case origin
        case location
        case created
        case numEpisodes
        
        var tintColor: UIColor {
            switch self {
            case .status:
                return .systemBlue
            case .gender:
                return .systemRed
            case .type:
                return .systemPurple
            case .species:
                return .systemGreen
            case .origin:
                return .systemGray
            case .location:
                return .systemBrown
            case .created:
                return .systemCyan
            case .numEpisodes:
                return .systemOrange
            }
        }
        
        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .numEpisodes:
                return UIImage(systemName: "bell")
            }
        }
        
        var titleString: String {
            switch self {
            case .created:
                return "BIRTH DATE"
            case .numEpisodes:
                return "EPISODES COUNT"
            default:
                return rawValue.uppercased()
            }
        }
    }
    
    // MARK: - Init
    
    init(type: `Type`, value: String) {
        self.type = type
        self.value = value
    }
}
