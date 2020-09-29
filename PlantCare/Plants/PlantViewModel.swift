//
//  PlantViewModel.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-23.
//

import Foundation
import Combine

class PlantViewModel: ObservableObject {
    private var plantService = PlantService()
    @Published var plantData: PlantData = PlantData(owner: "", ownerId: "", plants: [Plant]())
    var cancellationToken: AnyCancellable?
    
    init() {
        getPlants()
    }
}

extension PlantViewModel {
    func getPlants() {
        cancellationToken = plantService.mock_fetchPlants()
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(
                receiveCompletion: { _ in },
                receiveValue: {
                    self.plantData = $0
                }
            )
    }
}
