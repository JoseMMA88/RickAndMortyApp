//
//  CharacterCollectionViewCell.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 20/12/23.
//

import UIKit

/// Shows Character data
final class CharacterCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "CharacterCollectionViewCell"
    
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy private var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .medium)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        return label
    }()
    
    lazy private var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        return label
    }()
    
    lazy private var nameStatusStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            statusLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 3
        stackView.axis = .vertical
        
        return stackView
    }()
    
    lazy private var mainView: UIView = {
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            nameStatusStackView
        ])
        stackView.spacing = 3
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let view = UIView()
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }()
    
    
    struct Model {
        let name: String
        let imageURL: URL?
        let status: Status
        
        var characterStatusText: String {
            return status.rawValue
        }
        
        public func fetchImage(completion: @escaping(Result<Data, Error>) -> Void) {
            guard let url = imageURL else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? URLError(.badServerResponse)))
                    return
                }
                completion(.success(data))
            }.resume()
        }
    }
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    //MARK: - Functions
    
    private func addConstraints() {
        contentView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
        
    }
    
    public func configure(with model: Model) {
        nameLabel.text = model.name
        statusLabel.text = model.characterStatusText
        model.fetchImage { [weak self]  result in
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
}
