//
//  PlantViewModel.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-23.
//

import Foundation
import Combine

class PlantViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    var cancellationToken: AnyCancellable?
    
    init() {
        getPlants()
    }
}

extension PlantViewModel {
    func getPlants() {
        cancellationToken = PlantDB.request(.userPlants)
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(
                receiveCompletion: {_ in},
                receiveValue: {
                    self.plants = $0.plants
                }
            )
    }
}
