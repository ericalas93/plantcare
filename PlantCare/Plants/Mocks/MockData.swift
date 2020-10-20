//
//  MockPlant.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-30.
//

import Foundation

let mockPlantNoNotes = Plant(id: "mockplant", name: "Eric", lastWatered: Date(), waterFrequency: 10, lastMisted: Date(), mistFrequency: 5, lastFertilized: Date(), fertilizeFrequency: 15, imageUrl: "https://img.crocdn.co.uk/images/products2/pl/20/00/03/20/pl2000032091.jpg", family: "Fam", waterAmount: "200ml", sunAmount: "High", temperature: "16-20°C", fertilizerAmount: "150g", notes: "", ownerId: "unknown")
let mockPlantWithNotes = Plant(id: "mockplant", name: "Eric", lastWatered: Date(), waterFrequency: 10, lastMisted: Date(), mistFrequency: 5, lastFertilized: Date(), fertilizeFrequency: 15, imageUrl: "https://img.crocdn.co.uk/images/products2/pl/20/00/03/20/pl2000032091.jpg", family: "Fam", waterAmount: "200ml", sunAmount: "High", temperature: "16-20°C", fertilizerAmount: "150g", notes: "Some Notes here", ownerId: "unknown")

let mockHouse = House(id: "unknown", ownerId: "unknown", ownerEmail: "alas.eric@gmail.com", sharedWith: [], name: "Mock Home")
let mockUserData = UserData(houses: [mockHouse], currentHomeId: "unknown", plants: [mockPlantNoNotes, mockPlantWithNotes])

let mockPlantViewModel = PlantCareViewModel_mock();
