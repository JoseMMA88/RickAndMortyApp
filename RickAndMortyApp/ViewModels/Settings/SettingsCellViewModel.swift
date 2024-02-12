//
//  SettingCellViewModel.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 12/2/24.
//

import UIKit

struct SettingsCellViewModel: Identifiable, Hashable {
    
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
    
    private let type: SettingsOption
    
    // MARK: - Initializers
    
    init(type: SettingsOption) {
        self.type = type
    }
    
}
