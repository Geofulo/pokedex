//
//  BookmarksView.swift
//  Pokedex
//
//  Created by Geovanni Fuentes on 2023-05-19.
//

import Foundation
import SwiftUI

struct BookmarksView: View {
    // MARK: - Dependencies
    @ObservedObject var viewModel: BookmarksViewModel
    
    // MARK: - View
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.pokemons) { pokemon in
                    HStack {
                        AsyncImage(url: URL(string: pokemon.icon ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Text(pokemon.name.uppercased())
                            .font(.headline)
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
        }
        .navigationTitle("Bookmarks")
        .onAppear {
            viewModel.onLoadBookmarksPressed()
        }
    }
}

// MARK: - Previews
struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = BookmarksViewModel(localDataService: PreviewLocalDataService())
        return BookmarksView(viewModel: viewModel)
    }
}
