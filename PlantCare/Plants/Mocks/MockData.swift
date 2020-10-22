//
//  MockPlant.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-30.
//

import Foundation

let mockPlantNoNotes = Plant(id: "mockplant1", name: "Mock Plant 1", lastWatered: Date(), waterFrequency: 10, lastMisted: Date(), mistFrequency: 5, lastFertilized: Date(), fertilizeFrequency: 15, imageUrl: "https://img.crocdn.co.uk/images/products2/pl/20/00/03/20/pl2000032091.jpg", family: "Fam", waterAmount: "200ml", sunAmount: "High", temperature: "16-20°C", fertilizerAmount: "150g", notes: "", ownerId: "unknown")
let mockPlantWithNotes = Plant(id: "mockplant2", name: "Mock Plant 2", lastWatered: Date(), waterFrequency: 10, lastMisted: Date(), mistFrequency: 5, lastFertilized: Date(), fertilizeFrequency: 15, imageUrl: "https://img.crocdn.co.uk/images/products2/pl/20/00/03/20/pl2000032091.jpg", family: "Fam", waterAmount: "200ml", sunAmount: "High", temperature: "16-20°C", fertilizerAmount: "150g", notes: "Some Notes here", ownerId: "unknown")
let mockPlantWithNotes2 = Plant(id: "mockplant3", name: "Mock Plant 3", lastWatered: Date(), waterFrequency: 10, lastMisted: Date(), mistFrequency: 5, lastFertilized: Date(), fertilizeFrequency: 15, imageUrl: "https://img.crocdn.co.uk/images/products2/pl/20/00/03/20/pl2000032091.jpg", family: "Fam", waterAmount: "200ml", sunAmount: "High", temperature: "16-20°C", fertilizerAmount: "150g", notes: "Some Notes here", ownerId: "unknown2")

let mockHouse = House(id: "unknown", ownerId: "unknown", ownerEmail: "alas.eric@gmail.com", sharedWith: [SharingContact(ownerId: "unknown2", email: "example@gmail.com")], shareRequests: [], name: "Mock Home")
let mockHouse2 = House(id: "unknown2", ownerId: "unknown2", ownerEmail: "example@gmail.com", sharedWith: [], shareRequests: [], name: "Mock Home 2")
let mockUserData = UserData(houses: [mockHouse, mockHouse2], currentHomeId: "unknown", plants: [mockPlantNoNotes, mockPlantWithNotes, mockPlantWithNotes2])

let mockPlantViewModel = PlantCareViewModel_mock();
