//
//  PlantDBAPI.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-23.
//

import Foundation
import Combine

enum PlantDB {
    static let apiClient = APIClient()
//    static let baseUrl = URL(string: "https://run.mocky.io/v3/6d3a9bbd-0d6f-4472-8e5b-8421cc026611")
    static let baseUrl = URL(string: "https://run.mocky.io/v3/4d29463b-4e77-4d22-b879-d3091c3124a1")
}

enum APIPath: String {
    case userPlants = "" // TODO: when not using mock add route and user ID
}

extension PlantDB {
    static func request(_ path: APIPath) -> AnyPublisher<PlantResponse, Error> {
        
        guard let components = URLComponents(url: baseUrl!.appendingPathComponent(path.rawValue), resolvingAgainstBaseURL: true)
             else { fatalError("Couldn't create URLComponents") }
         
         let request = URLRequest(url: components.url!)
         
         return apiClient.run(request)
             .map(\.value)
             .eraseToAnyPublisher()
     }
}
