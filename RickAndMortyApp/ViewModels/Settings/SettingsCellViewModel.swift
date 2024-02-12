//
//  SettingCellViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 12/2/24.
//

import UIKit

struct SettingsCellViewModel: Identifiable {
    
    // MARK: - Properties
    
    let id = UUID()
    
    public var image: UIImage? {
        return type.iconImage
    }
    
    public var title: String {
        return type.displayTitle
    }
    
    public var imageContainerColor: UIColor {
        return type.iconContainerColor
    }
    
    public let type: SettingsOption
    public let action: (SettingsOption) -> Void
    
    // MARK: - Initializers
    
    init(type: SettingsOption, action: @escaping (SettingsOption) -> Void) {
        self.type = type
        self.action = action
    }
    
}
