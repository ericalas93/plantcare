//
//  House.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-28.
//

import Foundation

struct UserData: Decodable {
    var houses: [House]
    var currentHomeId: String?
    var plants: [Plant] = []
    
    enum CodingKeys: String, CodingKey {
        case houses
        case currentHomeId
    }
}

struct House: Decodable, Identifiable {
    let id: String
    let ownerId: String
    let ownerEmail: String?
    let sharedWith: Array<SharingContact>
    let shareRequests: Array<SharingContact>
    var name: String
    var firstName: String?
    var lastName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId
        case name
        case ownerEmail
        case sharedWith
        case shareRequests
    }
}

struct SharingContact: Decodable {
    let ownerId: String
    let email: String
}
