//
//  NetworkClient.swift
//  Pokedex
//
//  Created by Geovanni Fuentes on 2023-05-18.
//

import Foundation
import Combine

struct NetworkClient {
    /// Perform the URL request using ``URLSession`` to response with a publisher ``AnyPublisher``
    static func perform<T: Decodable>(_ request: String) -> AnyPublisher<T, Error> {
        let urlRequest = URLRequest(url: URL(string: request)!)
        print("[Network] Request: \(urlRequest)")
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map { data, _ in data }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ failure in
                print("[Network] Error: \(failure)")
                return failure
            })
            .eraseToAnyPublisher()
    }
}
