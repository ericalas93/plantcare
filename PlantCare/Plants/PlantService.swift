//
//  PlantService.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-27.
//

import Foundation
import Combine

final class PlantService {
    var decoder: JSONDecoder {
        let _decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        _decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return _decoder
    }
    
    func mock_fetchUserData() -> AnyPublisher<UserData, Error> {
        let jsonReader = JSONReader()
        let response = HTTPURLResponse(url: URL(string: "mockUrl")!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        let data = jsonReader.readLocalFile(forName: "mockHouses")
        
        return  Just((data: data, response: response))
            .map { house in
                
                return house.data!
                
            }
            .decode(type: UserData.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func mock_fetchPlants() -> AnyPublisher<PlantData, Error> {
        let jsonReader = JSONReader()
        let response = HTTPURLResponse(url: URL(string: "mockUrl")!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        let data = jsonReader.readLocalFile(forName: "data")
        
        return  Just((data: data, response: response))
            .map { $0.data! }
            .decode(type: PlantData.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

    }
}
