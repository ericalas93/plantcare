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
    @Published var userData: UserData = UserData(userId: "", houses: [House](), currentHome: nil)
  
    var cancellationToken: AnyCancellable?
    
    init() {
        getUserData()
    }

    // MARK: setters
    func setCurrentHome(ownerId: String) {
        let newCurrentHome = userData.houses.first { house in
            return house.ownerId == ownerId
        }
        userData.currentHome = newCurrentHome
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
        return userData.currentHome ?? nil
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

                    self.userData = UserData(userId: data.userId, houses: data.houses, currentHome: currentHome)
                }
            )
    }
}
