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
    @ObservedObject var editPlantModel: EditPlantViewModel

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
                PlantInformationCard(plant: plant, viewModel: viewModel, editPlantModel: editPlantModel)
            }
        }
    }
}

struct PlantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlantDetailView(viewModel: PlantCareViewModel(), editPlantModel: EditPlantViewModel(nil), close: { }, plant: mockPlantNoNotes)
    }
}
