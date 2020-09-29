//
//  House.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-28.
//

import Foundation

struct UserData: Decodable {
    let userId: String
    let houses: [House]
    var currentHome: House?
    
    enum CodingKeys: String, CodingKey {
        case userId
        case houses
        case currentHome
    }
}

struct House: Decodable, Identifiable {
    let id: Int
    let ownerId: String
    let name: String
    var plants: [Plant]
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId
        case name
        case plants
    }
}
