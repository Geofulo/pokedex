//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Geovanni Fuentes on 2023-05-18.
//

import SwiftUI

@main
struct PokedexApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel(dataService: NetworkDataService(), localDataService: LiveLocalDataService()))
        }
    }
}
