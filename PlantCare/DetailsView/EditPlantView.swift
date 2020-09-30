//
//  EditPlantView.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-29.
//

import SwiftUI

struct EditPlantView: View {
    @ObservedObject var plant: EditPlantViewModel

    var body: some View {
        Text(plant.name)
    }
}

struct EditPlantView_Previews: PreviewProvider {
    static var previews: some View {
        let plant = Plant(id: 1, name: "Eric", lastWatered: Date(), nextWater: Date(), lastMisted: Date(), nextMist: Date(), lastFertilized: Date(), nextFertilize: Date(), imageUrl: "https://img.crocdn.co.uk/images/products2/pl/20/00/03/20/pl2000032091.jpg", family: "Fam", waterAmount: "200ml", sunAmount: "High", temperature: "16-20°C", fertilizerAmount: "150g", notes: "")
        EditPlantView(plant: EditPlantViewModel(plant))
    }
}
