//
//  PlantInformationCard.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-24.
//

import SwiftUI

struct PlantInformationCard: View {
    @State var expanded = false
    var plant: Plant
    @ObservedObject var viewModel: PlantCareViewModel

    var body: some View {
        VStack {
            HStack {
                Image(systemName: expanded ? "chevron.compact.down" : "chevron.compact.up")
                    .font(.system(size: 35))
                    .opacity(0.1)
                    .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/) {
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
                                Text("\(plant.name)")
                                    .font(Font.title.bold())
                                Text(plant.family)
                                    .font(.title2)
                                    .foregroundColor(Color.secondary)
                            }
                            Spacer()
                            NavigationLink(destination: EditPlantView(plant: EditPlantViewModel(plant))) {
                                Image(systemName: "pencil.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.blue)
                            }
                        }
                        HStack {
                            PlantRingView(last: plant.lastWatered, next: plant.nextWater, title: "Water", Icon: Image(systemName: "drop"), onUpdate: {
                                    viewModel.waterPlant(plantId: plant.id)
                                })
                                .frame(minWidth: 100)
                            Spacer()
                            Divider()
                            Spacer()
                            PlantRingView(last: plant.lastMisted, next: plant.nextMist, title: "Mist", Icon: Image(systemName: "cloud.rain"), onUpdate: { })
                                .frame(minWidth: 100)
                            Spacer()
                            Divider()
                            Spacer()
                            PlantRingView(last: plant.lastFertilized, next: plant.nextFertilize, title: "Fertilize", Icon: Image(systemName: "leaf"), onUpdate: { })
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
                                Text(plant.sunAmount)
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
                                Text(plant.waterAmount)
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
                                Text(plant.temperature)
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
                                Text(plant.fertilizerAmount)
                            }
                                .padding()
                            Divider()
                        }
                            .padding(.bottom)
                        Text("More Information")
                            .font(.title)
                        if plant.notes.isEmpty {
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
                            Text(plant.notes)
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
        PlantInformationCard(plant: Plant(id: 1, name: "Eric", lastWatered: Date(), nextWater: Date(), lastMisted: Date(), nextMist: Date(), lastFertilized: Date(), nextFertilize: Date(), imageUrl: "https://img.crocdn.co.uk/images/products2/pl/20/00/03/20/pl2000032091.jpg", family: "Fam", waterAmount: "200ml", sunAmount: "High", temperature: "16-20°C", fertilizerAmount: "150g", notes: ""), viewModel: PlantCareViewModel())
    }
}
