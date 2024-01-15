//
//  CharacterPhotoCollectionViewCell.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 14/1/24.
//

import UIKit

class CharacterPhotoCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Views
    
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    //MARK: - Properties
    
    static var identifier: String {
        String(describing: self)
    }
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    //MARK: - Configure
    
    public func configure(with viewModel: CharacterPhotoViewCellViewModel) {
        viewModel.fetchImage { [weak self]  result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.imageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
    
    //MARK: - Functions
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
