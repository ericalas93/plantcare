//
//  PlantDetailView.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-22.
//

import SwiftUI
import URLImage

struct PlantDetailView: View {
    @State var fullImage = false
    @Environment(\.presentationMode) var showingDetails
    @ObservedObject var viewModel: PlantCareViewModel
    var close: () -> Void

    var plant: Plant
    var body: some View {
        if self.fullImage == true {
            URLImage(
                URL(string: plant.imageUrl)!,
                placeholder: Image("PlantStock"),
                content: { imageWrapper in
                    GeometryReader { geo in
                        VStack {
                            Spacer()
                            imageWrapper.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .onTapGesture(count: 1) {
                                    self.fullImage.toggle()
                            }
                            Spacer()
                        }
                            .background(Color.black)
                            .ignoresSafeArea(.all)
                    }
                }
            )
        }
        if self.fullImage == false {
            ZStack {
                URLImage(
                    URL(string: plant.imageUrl)!,
                    placeholder: Image("PlantStock"),
                    content: { imageWrapper in
                        GeometryReader { geo in
                            imageWrapper.image
                                .resizable()
                                .frame(width: geo.size.width, height: 400)
                                .onTapGesture(count: 1) {
                                    self.fullImage.toggle()
                            }
                        }
                    }
                )
                PlantDetailBackButton(close: close)
                PlantInformationCard(plant: plant, viewModel: viewModel)
            }
        }
    }
}

struct PlantDetailView_Previews: PreviewProvider {
    static var previews: some View {
//        PlantDetailView(plant: Plant(id: 1, name: "Eric", lastWatered: Date(), nextWater: Date(), lastMisted: Date(), nextMist: Date(), lastFertilized: Date(), nextFertilize: Date(), imageUrl: "https://img.crocdn.co.uk/images/products2/pl/20/00/03/20/pl2000032091.jpg", family: "Fam"))
        PlantDetailView(viewModel: PlantCareViewModel(), close: { }, plant: Plant(id: 1, name: "Eric", lastWatered: Date(), nextWater: Date(), lastMisted: Date(), nextMist: Date(), lastFertilized: Date(), nextFertilize: Date(), imageUrl: "https://img.crocdn.co.uk/images/products2/pl/20/00/03/20/pl2000032091.jpg", family: "Fam", waterAmount: "200ml", sunAmount: "High", temperature: "16-20°C", fertilizerAmount: "150g", notes: ""))
    }
}
