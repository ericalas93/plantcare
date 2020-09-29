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

                        Text("\(plant.name)")
                            .font(Font.title.bold())
                        Text(plant.family)
                            .font(.title2)
                            .foregroundColor(Color.secondary)
                        HStack {
                            PlantRingView(last: plant.lastWatered, next: plant.nextWater, title: "Water", Icon: Image(systemName: "drop"))
                                .frame(minWidth: 100)
                            Spacer()
                            Divider()
                            Spacer()
                            PlantRingView(last: plant.lastMisted, next: plant.nextMist, title: "Mist", Icon: Image(systemName: "cloud.rain"))
                                .frame(minWidth: 100)
                            Spacer()
                            Divider()
                            Spacer()
                            PlantRingView(last: plant.lastFertilized, next: plant.nextFertilize, title: "Fertilize", Icon: Image(systemName: "leaf"))
                                .frame(minWidth: 100)
                        }
                            .frame(maxHeight: 100)
                        .padding(.bottom)
                        Divider()
                        VStack {
                            HStack {
                                Image(systemName: "sun.max")
                                    .font(.system(size: 24))
                                    .frame(width: 24)
                                Text("Sunlight")
                                    .font(Font.title3.bold())
                                Spacer()
                                Text("High")
                            }
                            .padding()
                            Divider()
                            HStack {
                                Image(systemName: "drop")
                                    .font(.system(size: 24))
                                    .frame(width: 24)

                                Text("Water")
                                    .font(Font.title3.bold())
                                Spacer()
                                Text("250ml")
                            }
                            .padding()
                            Divider()
                            HStack {
                                Image(systemName: "thermometer")
                                    .font(.system(size: 24))
                                    .frame(width: 24)
                                    .foregroundColor(Color("GreenDark"))

                                Text("Temperature")
                                    .font(Font.title3.bold())
                                Spacer()
                                Text("16-20°C")
                            }
                            .padding()
                            Divider()
                            HStack {
                                Image(systemName: "leaf")
                                    .font(.system(size: 24))
                                    .frame(width: 24)

                                Text("Fertilizer")
                                    .font(Font.title3.bold())
                                Spacer()
                                Text("150mg")
                            }
                            .padding()
                            Divider()
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
        PlantInformationCard(plant: Plant(id: 1, name: "Eric", lastWatered: Date(), nextWater: Date(), lastMisted: Date(), nextMist: Date(), lastFertilized: Date(), nextFertilize: Date(), imageUrl: "https://img.crocdn.co.uk/images/products2/pl/20/00/03/20/pl2000032091.jpg", family: "Fam"))
    }
}
