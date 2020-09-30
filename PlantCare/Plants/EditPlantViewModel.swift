//
//  EditPlantViewModel.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-29.
//

import Foundation

class EditPlantViewModel: ObservableObject {
    @Published var name: String
    init(_ plant: Plant) {
        self.name = plant.name + "a"
    }
}
