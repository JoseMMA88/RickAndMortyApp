//
//  CharacterEpisodeCollectionViewCell.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 14/1/24.
//

import UIKit

final class CharacterEpisodeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views
    
    lazy var seasonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .regular)
        
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        
        return label
    }()
    
    lazy var airDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .light)
        
        return label
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            seasonLabel,
            airDateLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    // MARK: - Properties
    
    static var identifier: String {
        String(describing: self)
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        addSubview(mainStackView)
        setUpLayer()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Configure
    
    public func configure(with viewModel: CharacterEpisodeViewCellViewModel) {
        viewModel.registerForData { [weak self] model in
            // Main Queue
            guard let self = self else { return }
            self.nameLabel.text = model.name
            self.seasonLabel.text = "Episode " + model.episode
            self.airDateLabel.text = "Aired on " + model.air_date
        }
        viewModel.fetchEpisodeInfo()
        contentView.layer.borderColor = viewModel.borderColor.cgColor
    }
    
    // MARK: - Functions
    
    override func prepareForReuse() {
        seasonLabel.text = nil
        nameLabel.text = nil
        airDateLabel.text = nil
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            mainStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    private func setUpLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
    }
}
