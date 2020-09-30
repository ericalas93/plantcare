//
//  HouseViewModel.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-28.
//

import Foundation
import Combine

class PlantCareViewModel: ObservableObject {
    private var plantService = PlantService()
    @Published var userData: UserData = UserData(userId: "", houses: [House](), currentHomeId: nil)
  
    var cancellationToken: AnyCancellable?
    
    init() {
        getUserData()
    }

    // MARK: setters
    func setCurrentHome(ownerId: String) {
        let newCurrentHome = userData.houses.first { house in
            return house.ownerId == ownerId
        }
        userData.currentHomeId = newCurrentHome!.id
    }
    
    // MARK: getters
    func getPlantToUpdate(plantId: Int) -> (houseIdx: Int, plantIdx: Int) {
        let houseIdx = userData.houses.firstIndex { house in
            return house.id == userData.currentHomeId
        }

        let plantIdx = userData.houses[houseIdx!].plants.firstIndex { plant in
            return plant.id == plantId
        }
        
        return (houseIdx: houseIdx!, plantIdx: plantIdx!)

    }
    
    // MARK: updaters
    func waterPlant(plantId: Int) {
        let (houseIdx, plantIdx) = getPlantToUpdate(plantId: plantId)

        // TODO: get frequency here
        let nextWaterDate = Calendar.current.date(byAdding: .day, value: 10, to: Date())
        userData.houses[houseIdx].plants[plantIdx].nextWater = nextWaterDate!
        userData.houses[houseIdx].plants[plantIdx].lastWatered = Date()
    }

    // MARK: selectors
    var currentHousePlants: [Plant] {
        if (currentHouse == nil) {
            return [];
        }

        return currentHouse!.plants
    }
    
    var houses: [House] {
        return userData.houses
    }
    
    var currentHouse: House? {
        if (userData.currentHomeId == nil) {
            return nil
        }
        return userData.houses.first { house in
            return house.id == userData.currentHomeId
        }
    }
}

extension PlantCareViewModel {
    func getUserData() {
        cancellationToken = plantService.mock_fetchUserData()
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { data in
                    let currentHome = data.houses.first { house in
                        return house.ownerId == data.userId
                    }

                    self.userData = UserData(userId: data.userId, houses: data.houses, currentHomeId: currentHome!.id)
                }
            )
    }
}
