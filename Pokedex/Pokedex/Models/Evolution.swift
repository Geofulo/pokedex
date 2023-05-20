//
//  Evolutions.swift
//  Pokedex
//
//  Created by Geovanni Fuentes on 2023-05-18.
//

import Foundation

struct Evolution: Decodable {
    // MARK: - Properties
    let id: Int
    let name: String
    var icon: String? = nil
    var trigger: String
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id
        case chain
    }
    
    enum ChainCodingKeys: String, CodingKey {
        case species
        case details = "evolution_details"
        case evolve = "evolves_to"
    }
    
    enum SpeciesCodingKeys: String, CodingKey {
        case name
    }
    
    // MARK: - Init
    init(id: Int = 0, name: String, icon: String? = nil, trigger: String = "") {
        self.id = id
        self.name = name
        self.icon = icon
        self.trigger = trigger
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let chainContainer = try container.nestedContainer(keyedBy: ChainCodingKeys.self, forKey: .chain)
        
        guard let chain = try chainContainer.decode([EvolutionChain].self, forKey: .evolve).first else {
            throw NSError(domain: "Decoder", code: 0)
        }
        
        id = try container.decode(Int.self, forKey: .id)
        name = chain.name
        trigger = chain.trigger
    }
}

struct EvolutionChain: Decodable {
    // MARK: - Properties
    let name: String
    let trigger: String
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case species
        case details = "evolution_details"
    }
    
    enum SpeciesCodingKeys: String, CodingKey {
        case name
    }
    
    // MARK: - Init
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let speciesContainer = try container.nestedContainer(keyedBy: SpeciesCodingKeys.self, forKey: .species)
        
        let detail = try container.decode([EvolutionDetail].self, forKey: .details)
        
        name = try speciesContainer.decode(String.self, forKey: .name)
        trigger = detail.first?.triggerName ?? ""
    }
}

struct EvolutionDetail: Decodable {
    // MARK: - Properties
    var triggerName: String
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case trigger
    }
    
    enum TriggerCodingKeys: String, CodingKey {
        case name
    }
    
    // MARK: - Init
    init(triggerName: String) {
        self.triggerName = triggerName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let triggerContainer = try container.nestedContainer(keyedBy: TriggerCodingKeys.self, forKey: .trigger)
        
        triggerName = try triggerContainer.decode(String.self, forKey: .name)
    }
}
