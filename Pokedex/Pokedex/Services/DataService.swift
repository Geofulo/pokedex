//
//  DataService.swift
//  Pokedex
//
//  Created by Geovanni Fuentes on 2023-05-18.
//

import Foundation
import Combine

// MARK: - Protocol
protocol DataService {
    func fetchRandomPokemon() -> AnyPublisher<Pokemon, Error>
    func fetchEvolution(for: Int) -> AnyPublisher<Evolution, Error>
}

// MARK: - Live Service
class NetworkDataService: DataService {
    func fetchRandomPokemon() -> AnyPublisher<Pokemon, Error> {
        let id = Int.random(in: 1..<1016) // Random number based on amount of known pokemon species: https://bulbapedia.bulbagarden.net/wiki/Pokémon_(species)
        return NetworkClient.perform("https://pokeapi.co/api/v2/pokemon/\(id)/")
    }
    
    func fetchEvolution(for id: Int) -> AnyPublisher<Evolution, Error> {
        return NetworkClient.perform("https://pokeapi.co/api/v2/evolution-chain/\(id)/")
    }
}

// MARK: - Preview Mock Service
class PreviewDataService: DataService {
    func fetchRandomPokemon() -> AnyPublisher<Pokemon, Error> {
        Just(
            Pokemon(
                name: "Clefairy",
                image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/35.png",
                icon: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/35.png"
            )
        )
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    func fetchEvolution(for id: Int) -> AnyPublisher<Evolution, Error> {
        Just(
            Evolution(
                name: "Clefairy",
                icon: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/35.png",
                trigger: "Level-up"
            )
        )
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
}
