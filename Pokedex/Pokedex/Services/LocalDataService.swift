//
//  LocalDataService.swift
//  Pokedex
//
//  Created by Geovanni Fuentes on 2023-05-19.
//

import Foundation
import Combine

// MARK: - Constants
enum LocalDataConstants {
    static let bookmarks = "bookmarks"
}

// MARK: - Protocol
protocol LocalDataService {
    func fetchBookmarks() -> [Pokemon]?
    func saveBookmark(pokemon: Pokemon) -> Void
    func removeBookmark(pokemon: Pokemon) -> Void
    func isBookmark(pokemon: Pokemon) -> Bool
}

// MARK: - Live Service
class LiveLocalDataService: LocalDataService {
    func fetchBookmarks() -> [Pokemon]? {
        do {
            let decoder = JSONDecoder()
            guard let data = UserDefaults.standard.data(forKey: LocalDataConstants.bookmarks) else {
                return nil
            }
            return try decoder.decode([Pokemon].self, from: data)
        } catch {
            print("[Bookmarks] error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveBookmark(pokemon: Pokemon) {
        do {
            let encoder = JSONEncoder()
            guard var pokemonList = fetchBookmarks() else {
                let data = try encoder.encode([pokemon])
                UserDefaults.standard.set(data, forKey: LocalDataConstants.bookmarks)
                return
            }
            pokemonList.append(pokemon)
            let data = try encoder.encode(pokemonList)
            UserDefaults.standard.set(data, forKey: LocalDataConstants.bookmarks)
        } catch {
            print("[Bookmarks] error: \(error.localizedDescription)")
        }
    }
    
    func removeBookmark(pokemon: Pokemon) {
        do {
            let encoder = JSONEncoder()
            guard var pokemonList = fetchBookmarks() else { return }
            pokemonList.removeAll(where: { $0.id == pokemon.id })
            let data = try encoder.encode(pokemonList)
            UserDefaults.standard.set(data, forKey: LocalDataConstants.bookmarks)
        } catch {
            print("[Bookmarks] error: \(error.localizedDescription)")
        }
    }
    
    func isBookmark(pokemon: Pokemon) -> Bool {
        guard let pokemonList = fetchBookmarks() else { return false }
        return pokemonList.contains(where: { $0.id == pokemon.id })
    }
}

// MARK: - Preview Mock Service
class PreviewLocalDataService: LocalDataService {
    func fetchBookmarks() -> [Pokemon]? {
        [
            Pokemon(
                name: "Clefairy",
                image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/35.png",
                icon: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/35.png"
            ),
            Pokemon(
                name: "Clefairy",
                image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/35.png",
                icon: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/35.png"
            )
        ]
    }
    
    func saveBookmark(pokemon: Pokemon) { }
    
    func removeBookmark(pokemon: Pokemon) { }
    
    func isBookmark(pokemon: Pokemon) -> Bool { return false } 
}
