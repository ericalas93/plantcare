//
//  PlantInformationCard.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-24.
//

import SwiftUI

struct PlantInformationCard: View {
    @State var expanded = false
    @State var inEditMode = false
    var plant: Plant
    @ObservedObject var viewModel: PlantCareViewModel
    @ObservedObject var editPlantModel: EditPlantViewModel

    var body: some View {
        let plantData = viewModel.userData.plants.first { _plant in
            return _plant.id == plant.id
        }!

        VStack {
            HStack {
                Image(systemName: expanded ? "chevron.compact.down" : "chevron.compact.up")
                    .font(.system(size: 35))
                    .opacity(0.1)
                    .onTapGesture(count: 1) {
                        self.expanded.toggle()
                }

            }
                .frame(maxWidth: .infinity)
                .padding(10)
                .padding(.bottom, 0)

            HStack {
                ScrollView(.vertical) {

                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(plantData.name)")
                                    .font(Font.title.bold())
                                Text(plantData.family)
                                    .font(.title2)
                                    .foregroundColor(Color.secondary)
                            }
                            Spacer()
                            NavigationLink(destination: EditPlantView(plant: editPlantModel, viewModel: viewModel, inEditMode: $inEditMode, shouldResetForm: false)
                                    .navigationTitle("")
                                    .navigationBarHidden(true)) {
                                Image(systemName: "pencil.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.blue)
                            }
                        }
                        HStack {
                            PlantRingView(last: plant.lastWatered, frequency: plantData.waterFrequency, title: "Water", Icon: Image(systemName: "drop"), onUpdate: {
                                    viewModel.waterPlant(plantId: plant.id)
                                })
                                .frame(minWidth: 100)
                            Spacer()
                            Divider()
                            Spacer()
                            PlantRingView(last: plant.lastMisted, frequency: plantData.mistFrequency, title: "Mist", Icon: Image(systemName: "cloud.rain"), onUpdate: { })
                                .frame(minWidth: 100)
                            Spacer()
                            Divider()
                            Spacer()
                            PlantRingView(last: plant.lastFertilized, frequency: plantData.fertilizeFrequency, title: "Fertilize", Icon: Image(systemName: "leaf"), onUpdate: { })
                                .frame(minWidth: 100)
                        }
                            .frame(maxHeight: 5150)
                            .padding(.bottom)
                        Divider()
                        VStack {
                            HStack {
                                Image(systemName: "sun.max")
                                    .font(.system(size: 24))
                                    .frame(width: 24)
                                    .foregroundColor(Color("Sun"))

                                Text("Sunlight")
                                    .font(Font.title3.bold())
                                Spacer()
                                Text(plantData.sunAmount)
                            }
                                .padding()
                            Divider()
                            HStack {
                                Image(systemName: "drop")
                                    .font(.system(size: 24))
                                    .frame(width: 24)
                                    .foregroundColor(Color("Water"))

                                Text("Water")
                                    .font(Font.title3.bold())
                                Spacer()
                                Text(plantData.waterAmount)
                            }
                                .padding()
                            Divider()
                            HStack {
                                Image(systemName: "thermometer")
                                    .font(.system(size: 24))
                                    .frame(width: 24)
                                    .foregroundColor(Color("Thermometer"))

                                Text("Temperature")
                                    .font(Font.title3.bold())
                                Spacer()
                                Text(plantData.temperature)
                            }
                                .padding()
                            Divider()
                            HStack {
                                Image(systemName: "leaf")
                                    .font(.system(size: 24))
                                    .frame(width: 24)
                                    .foregroundColor(Color("Fertilizer"))

                                Text("Fertilizer")
                                    .font(Font.title3.bold())
                                Spacer()
                                Text(plantData.fertilizerAmount)
                            }
                                .padding()
                            Divider()
                        }
                            .padding(.bottom)
                        Text("More Information")
                            .font(.title)
                        if plantData.notes.isEmpty {
                            HStack {
                                Spacer()
                                VStack {
                                    Image("HappyPlant")
                                        .resizable()
                                        .frame(width: 150, height: 150)
                                    Text("Nothing else to worry about!")
                                }
                                    .padding()
                                Spacer()
                            }
                        } else {
                            Text(plantData.notes)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom)
                        }
                    }
                        .padding([.trailing, .leading])
                        .padding(.bottom, 250)

                }

                Spacer()
            }
            Spacer()
        }
            .padding(.top, 8)
            .background(Color.white)
            .cornerRadius(30)
            .shadow(radius: 30)
            .offset(x: 0, y: 250)
            .offset(y: expanded ? -150 : 0)
            .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))


    }
}

struct PlantInformationCard_Previews: PreviewProvider {
    static var previews: some View {
        PlantInformationCard(plant: mockPlantNoNotes, viewModel: PlantCareViewModel(), editPlantModel: EditPlantViewModel(nil))
    }
}
