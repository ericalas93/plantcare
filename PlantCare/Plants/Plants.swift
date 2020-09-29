//
//  Plants.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-23.
//

import Foundation

struct PlantData: Decodable {
    let owner: String
    let ownerId: String
    let plants: [Plant]
    
    enum CodingKeys: String, CodingKey {
        case plants = "results"
        case owner
        case ownerId
    }
}

struct Plant: Decodable, Identifiable {
    var id : Int
    var name: String
    var lastWatered: Date
    var nextWater :  Date
    var lastMisted : Date
    var nextMist : Date
    var lastFertilized : Date
    var nextFertilize : Date
    var imageUrl : String
    var family : String
}
