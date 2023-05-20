# Pokedex App
Test code assignment

## Assignment description

The parents want to be able to visit the app and see at least one randomly chosen new Pokémon. This Pokémon should change each time they visit the page. The kids can choose one Pokémon for their parents to show them, and the page will display details of that Pokémon for the parents to read. If the kids are not interested in the Pokémon shown, the parent wants to be able to select a new random match. The parents also want to bookmark certain Pokémon to revisit later.

The kids are very curious! They want to see the image, name, possible evolutions, and requirements for evolution in a kid-friendly, colorful UI. If the kids collect a Pokémon in Pokémon GO that they have never seen before, they want to learn more about that Pokémon. The kids are not always good at spelling and might be unhappy if their search returned no results! A mini library that lists Pokémon by name or relevant search keywords would be super helpful.

PokéAPI has a great connection with the Pokémon GO community, with a fresh REST API v2 (https://pokeapi.co/docs/v2) and a beta running GraphQL API (https://pokeapi.co/docs/graphql).

## Tech decisions

- Clean Arquitecture + Combine framework + SwiftUI
- I have used the REST API endpoint `/pokemon` and `/evolution-chain`
- I have used the `AsyncImage` component from SwiftUI to handle images and cache
- I have used protocols for services so it's easy to test and for design previews
- I have used `UserDefaults` to save bookmarks in local persitent data
- I have used `Codable` models to handle API responses
