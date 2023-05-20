//
//  MainViewModel.swift
//  Pokedex
//
//  Created by Geovanni Fuentes on 2023-05-18.
//

import Foundation
import Combine
import SwiftUI

class MainViewModel: ObservableObject {
    // MARK: - Dependencies    
    let dataService: DataService
    let localDataService: LocalDataService
    
    // MARK: - Properties
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var pokemon: Pokemon?
    @Published var isBookmark: Bool = false
    
    init(dataService: DataService, localDataService: LocalDataService) {
        self.dataService = dataService
        self.localDataService = localDataService
        
        subscribe()
    }
}

// MARK: - Private functions
extension MainViewModel {
    func subscribe() {
        $pokemon.sink { [weak self] pokemon in
            guard let pokemon = pokemon else { return }
            self?.isBookmark = self?.localDataService.isBookmark(pokemon: pokemon) ?? false
        }
        .store(in: &cancellables)
    }
}

// MARK: - Public functions
extension MainViewModel {
    func onGetRandomPokemonPressed() {
        dataService
            .fetchRandomPokemon()
            .receive(on: RunLoop.main)
            .sink { error in
                if case let .failure(error) = error {
                    print(error.localizedDescription)
                }
            } receiveValue: { pokemon in
                self.pokemon = pokemon
            }
            .store(in: &cancellables)
    }
    
    func onGetPokemonDetailsPressed() {
        guard let pokemon = pokemon else { return }
        dataService.fetchEvolution(for: pokemon.id)
            .receive(on: RunLoop.main)
            .sink { error in
                if case let .failure(error) = error {
                    print(error.localizedDescription)
                }
            } receiveValue: { evolution in
                self.pokemon?.evolution = evolution
            }
            .store(in: &cancellables)
    }
    
    func onSaveBookmarkPressed() {
        guard let pokemon = pokemon else { return }
        localDataService.saveBookmark(pokemon: pokemon)
        isBookmark = true
    }
    
    func onRemoveBookmarkPressed() {
        guard let pokemon = pokemon else { return }
        localDataService.removeBookmark(pokemon: pokemon)
        isBookmark = false
    }
}
