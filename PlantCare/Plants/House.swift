//
//  House.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-28.
//

import Foundation

struct UserData: Decodable {
    let userId: String
    var houses: [House]
    var currentHomeId: Int?
    
    enum CodingKeys: String, CodingKey {
        case userId
        case houses
        case currentHomeId
    }
}

struct House: Decodable, Identifiable {
    let id: Int
    let ownerId: String
    var name: String
    var plants: [Plant]
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId
        case name
        case plants
    }
}
