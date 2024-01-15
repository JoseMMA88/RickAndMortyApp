//
//  CharacterEpisodeCollectionViewCell.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 14/1/24.
//

import UIKit

class CharacterEpisodeCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    
    static var identifier: String {
        String(describing: self)
    }
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    //MARK: - Configure
    
    public func configure(with viewModel: CharacterEpisodeViewCellViewModel) {
        
    }
    
    //MARK: - Functions
    
    override func prepareForReuse() {
        
    }
    
    private func setUpConstraints() {
        
    }
}
