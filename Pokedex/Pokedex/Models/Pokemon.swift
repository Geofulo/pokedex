//
//  Pokemon.swift
//  Pokedex
//
//  Created by Geovanni Fuentes on 2023-05-18.
//

import Foundation

struct Pokemon: Identifiable, Codable {
    // MARK: - Properties
    let id: Int
    let name: String
    let image: String?
    let icon: String?
    var evolution: Evolution? = nil
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sprites
    }
    
    enum SpritesCodingKeys: String, CodingKey {
        case front = "front_default"
        case other
    }

    enum OtherCodingKeys: String, CodingKey {
        case home
        case officialArtwork = "official-artwork"
    }

    enum AssetsCodingKeys: String, CodingKey {
        case front = "front_default"
    }
    
    // MARK: - Init
    init(id: Int = 0, name: String, image: String, icon: String) {
        self.id = id
        self.name = name
        self.image = image
        self.icon = icon
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let spritesContainer = try container.nestedContainer(keyedBy: SpritesCodingKeys.self, forKey: .sprites)
        let otherContainer = try spritesContainer.nestedContainer(keyedBy: OtherCodingKeys.self, forKey: .other)
        let assetsContainer = try otherContainer.nestedContainer(keyedBy: AssetsCodingKeys.self, forKey: .officialArtwork)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        image = try assetsContainer.decodeIfPresent(String.self, forKey: .front)
        icon = try spritesContainer.decodeIfPresent(String.self, forKey: .front)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var spritesContainer = container.nestedContainer(keyedBy: SpritesCodingKeys.self, forKey: .sprites)
        var otherContainer = spritesContainer.nestedContainer(keyedBy: OtherCodingKeys.self, forKey: .other)
        var assetsContainer = otherContainer.nestedContainer(keyedBy: AssetsCodingKeys.self, forKey: .officialArtwork)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try assetsContainer.encode(image, forKey: .front)
        try spritesContainer.encode(icon, forKey: .front)
    }
}
