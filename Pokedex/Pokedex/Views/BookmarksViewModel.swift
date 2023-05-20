//
//  BookmarksViewModel.swift
//  Pokedex
//
//  Created by Geovanni Fuentes on 2023-05-19.
//

import Foundation
import Combine
import SwiftUI

class BookmarksViewModel: ObservableObject {
    // MARK: - Dependencies
    let localDataService: LocalDataService
    
    // MARK: - Properties
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var pokemons: [Pokemon] = []
    
    init(localDataService: LocalDataService) {
        self.localDataService = localDataService
        
        subscribe()
    }
}

// MARK: - Private functions
extension BookmarksViewModel {
    func subscribe() {
        
    }
}

// MARK: - Public functions
extension BookmarksViewModel {
    func onLoadBookmarksPressed() {
        pokemons = localDataService.fetchBookmarks() ?? []
        print("[Bookmarks] pokemon: \(pokemons.count)")
    }
}
