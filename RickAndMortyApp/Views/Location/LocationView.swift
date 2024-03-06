//
//  LocationView.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 22/2/24.
//

import UIKit

protocol LocationViewDelegate: AnyObject {
    func locationView(_ : LocationView, didSelect location: Location)
}

final class LocationView: UIView {
    
    // MARK: - Properties
    
    public weak var delegate: LocationViewDelegate?
    
    private var viewModel: LocationViewViewModel? {
        didSet {
            spinner.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = 1
            }
        }
    }
    
    // MARK: - Views
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LocationTableViewCell.self,
                           forCellReuseIdentifier: LocationTableViewCell.identifier)
        tableView.alpha = 0
        tableView.isHidden = true
        
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        
        return spinner
    }()

    // MARK: - Initiliazers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        addSubview(spinner)
        spinner.startAnimating()
        addConstraints()
        configureTable()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Functions
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func configure(with viewModel: LocationViewViewModel) {
        self.viewModel = viewModel
    }

}

// MARK: - UITableViewDelegate

extension LocationView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let location = viewModel?.location(at: indexPath.row) else { return }
        
        delegate?.locationView(self,
                               didSelect: location)
    }
}

// MARK: - UITableViewDataSource

extension LocationView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel?.cellViewModels[indexPath.row] else {
            return UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier,
                                                       for: indexPath) as? LocationTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: model)
        
        return cell
    }
    
}
