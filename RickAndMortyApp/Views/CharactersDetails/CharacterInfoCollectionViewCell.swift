//
//  CharacterInfoCollectionViewCell.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 14/1/24.
//

import UIKit

final class CharacterInfoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var titleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 8
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.heightAnchor.constraint(equalToConstant: 30),
            icon.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        return icon
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var valueStackView: UIStackView = {
        let view = UIView()
        view.backgroundColor = .clear
        let stackView = UIStackView(arrangedSubviews: [
            iconImageView,
            valueLabel
        ])
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var valueContainerView: UIView = {
        let view = UIView()
        view.addSubview(valueStackView)
        NSLayoutConstraint.activate([
            valueStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            valueStackView.topAnchor.constraint(equalTo: view.topAnchor),
            valueStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            valueStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleContainerView,
            valueContainerView
        ])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
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
        contentView.layer.cornerRadius = 8
        contentView.addSubview(mainStackView)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Configure
    
    public func configure(with viewModel: CharacterInfoViewCellViewModel) {
        titleLabel.text = viewModel.title
        titleLabel.textColor = viewModel.tintColor
        valueLabel.text = viewModel.displayValue
        iconImageView.image = viewModel.iconImage
        iconImageView.tintColor = viewModel.tintColor
    }
    
    // MARK: - Functions
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        titleLabel.textColor = nil
        valueLabel.text = nil
        iconImageView.image = nil
        iconImageView.tintColor = nil
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mainStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor,  constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5),
        ])
    }
    
}
