//
//  MainView.swift
//  Pokedex
//
//  Created by Geovanni Fuentes on 2023-05-18.
//

import Foundation
import SwiftUI

struct MainView: View {
    // MARK: - Dependencies
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.scenePhase) var scenePhase
    
    // MARK: - Properties
    @State public var showPokemonDetail = false
    @State public var showBookmarks = false
    @State public var searchText = ""
    
    // MARK: - View
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                if let pokemon = viewModel.pokemon {
                    pokemonDetails(for: pokemon)
                }
                
                Spacer()
                
                buttonsView
            }
            .onAppear {
                if viewModel.pokemon == nil {
                    viewModel.onGetRandomPokemonPressed()
                }
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .bookmarks:
                    BookmarksView(viewModel: BookmarksViewModel(localDataService: LiveLocalDataService()))
                        .presentationDetents([.medium])
                }
            }
        }
    }
    
    // MARK: - Subviews
    @ViewBuilder private func pokemonDetails(for pokemon: Pokemon) -> some View {
        VStack {
            if !showPokemonDetail {
                Spacer()
            }
            
            VStack {
                if showPokemonDetail {
                    HStack {
                        Spacer()
                        
                        Image(systemName: "xmark")
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding()
                            .onTapGesture {
                                withAnimation(.linear) {
                                    showPokemonDetail = false
                                }
                            }
                            .foregroundColor(.white)
                    }
                }
                
                if let image = pokemon.image {
                    AsyncImage(url: URL(string: image)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            .background(Color.black.opacity(0.8))
            .cornerRadius(showPokemonDetail ? 0 : 20)
            .padding(.horizontal, showPokemonDetail ? 0 : 20)
            
            Text(pokemon.name.uppercased())
                .font(.largeTitle)
            
            if showPokemonDetail {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Evolutions")
                            .font(.headline)
                        
                        if let evolution = pokemon.evolution {
                            HStack(spacing: 15) {
                                Text("\(evolution.name.uppercased())")
                                    .font(.body)
                                
                                Text("\(evolution.trigger)")
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.yellow)
                                    )
                            }
                        } else {
                            Text("No evolutions found")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    if viewModel.isBookmark {
                        Image(systemName: "bookmark.fill")
                            .foregroundColor(.black)
                            .onTapGesture {
                                viewModel.onRemoveBookmarkPressed()
                            }
                    } else {
                        Image(systemName: "bookmark")
                            .foregroundColor(.black)
                            .onTapGesture {
                                viewModel.onSaveBookmarkPressed()
                            }
                    }
                }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
        }
        .onTapGesture {
            withAnimation(.linear) {
                if !showPokemonDetail {
                    viewModel.onGetPokemonDetailsPressed()
                    showPokemonDetail = true
                }
            }
        }
    }
    
    @ViewBuilder private var buttonsView: some View {
        if !showPokemonDetail {
            HStack {
                Spacer()
                Image(systemName: "magnifyingglass")
                Spacer()
                
                Button("Random pokemon") {
                    viewModel.onGetRandomPokemonPressed()
                }
                .padding()
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(10)
                .transition(.move(edge: .bottom))
                
                Spacer()
                NavigationLink(value: NavigationDestination.bookmarks) {
                    Image(systemName: "bookmark")
                        .foregroundColor(.black)
                }
                Spacer()
            }
        } else {
            Spacer()
        }
    }
}

// MARK: - Previews
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MainViewModel(dataService: PreviewDataService(), localDataService: PreviewLocalDataService())
        return MainView(viewModel: viewModel)
    }
}

