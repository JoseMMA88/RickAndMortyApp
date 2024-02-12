//
//  SettingsView.swift
//  RickAndMortyApp
//
//  Created by Jose Manuel Malagón Alba on 12/2/24.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - Properties
    
    let viewModel: SettingsViewViewModel
    
    let strings = ["A", "B", "C", "D", "E", "F"]
    
    // MARK: - Views
    
    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(Color(viewModel.imageContainerColor))
                        .cornerRadius(6)
                }
                Text(viewModel.title)
                    .padding(.leading, 10)
            }
            .padding(.bottom, 3)
        }
    }
    
    // MARK: - Init
    
    init(viewModel: SettingsViewViewModel) {
        self.viewModel = viewModel
    }

}

#Preview {
    SettingsView(viewModel: .init(cellViewModels: SettingsOption.allCases.compactMap({
        return .init(type: $0)
    })))
}
