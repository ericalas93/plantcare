//
//  Plants.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-23.
//

import Foundation
import SwiftUI

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
    var id: String
    var name: String
    var lastWatered: Date
    var waterFrequency: Int
    var lastMisted: Date
    var mistFrequency: Int
    var lastFertilized: Date
    var fertilizeFrequency: Int
    var imageUrl: String
    var family: String
    var waterAmount: String
    var sunAmount: String
    var temperature: String
    var fertilizerAmount: String
    var notes: String
    var ownerId: String

    var dictionary: [String: Any] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        return [
            "id": id,
            "name": name,
            "lastWatered": formatter.string(from: lastWatered),
            "waterFrequency": waterFrequency,
            "lastMisted": formatter.string(from: lastMisted),
            "mistFrequency": mistFrequency,
            "lastFertilized": formatter.string(from: lastFertilized),
            "fertilizeFrequency": fertilizeFrequency,
            "imageUrl": imageUrl,
            "family": family,
            "waterAmount": waterAmount,
            "sunAmount": sunAmount,
            "temperature": temperature,
            "fertilizerAmount": fertilizerAmount,
            "notes": notes,
            "ownerId": ownerId
        ]
    }
}
